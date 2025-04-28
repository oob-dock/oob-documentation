CREATE OR REPLACE FUNCTION payment_consent_count(start_date DATE, end_date DATE, is_automatic boolean)
    RETURNS TABLE
            (
                itp                   	     TEXT,
                quantity_request             BIGINT,
                quantity_consent_client      BIGINT,
                quantity_consent_non_client  BIGINT,
                itp_org_id					         TEXT,
                product                      TEXT,
                authorisation_flow           TEXT
            )
AS
$function$
DECLARE start_date_utc timestamptz;
DECLARE end_date_interval date;
DECLARE end_date_utc timestamptz;
BEGIN
    SELECT end_date + interval '1 day' into end_date_interval;
    SELECT start_date::date::timestamp AT TIME ZONE 'UTC' into start_date_utc;
    SELECT end_date_interval::date::timestamp AT TIME ZONE 'UTC' into end_date_utc;

    IF is_automatic THEN
        RETURN QUERY
          SELECT subquery.itp::TEXT                                                           itp,
            SUM(subquery.quantity_request)::BIGINT                                            quantity_request,
            SUM(subquery.quantity_consent_client)::BIGINT                                     quantity_consent_client,
            SUM(subquery.quantity_consent_non_client)::BIGINT                                 quantity_consent_non_client,
            (array_agg(subquery.itp_org_id order by subquery.quantity_request desc))[1]::TEXT itp_org_id,
            NULL                                                                              product,
            NULL                                                                              authorisation_flow
          FROM (SELECT get_conglomerate_name(t.org_name::TEXT)                                            itp,
            count(c.id)                                                                             quantity_request,
            count(c.id) FILTER(WHERE c.account_holder_status=1  or c.account_holder_status is null) quantity_consent_client,
            count(c.id) FILTER(WHERE c.account_holder_status=2)                                     quantity_consent_non_client,
            t.org_id::varchar                                                                       itp_org_id,
            null                                                                                    product,
            null                                                                                    authorisation_flow
          FROM consent c
            INNER JOIN tpp t ON c.id_tpp = t.id
          WHERE c.dt_creation BETWEEN start_date_utc AND end_date_utc
            AND c.tp_consent = 2
            AND c.tp_modality_payment IN (3,4,5)
          GROUP BY itp, t.org_id) subquery
          GROUP BY subquery.itp, subquery.itp_org_id
          ORDER BY itp ASC, quantity_request DESC;
    ELSE
        RETURN QUERY
          SELECT subquery.itp::TEXT                                                           itp,
            SUM(subquery.quantity_request)::BIGINT                                            quantity_request,
            SUM(subquery.quantity_consent_client)::BIGINT                                     quantity_consent_client,
            SUM(subquery.quantity_consent_non_client)::BIGINT                                 quantity_consent_non_client,
            (array_agg(subquery.itp_org_id order by subquery.quantity_request desc))[1]::TEXT itp_org_id,
            subquery.product::TEXT                                                            product,
            subquery.authorisation_flow::TEXT                                                 authorisation_flow
          FROM (SELECT get_conglomerate_name(t.org_name::TEXT)                                      itp,
            count(c.id)                                                                             quantity_request,
            count(c.id) FILTER(WHERE c.account_holder_status=1  or c.account_holder_status is null) quantity_consent_client,
            count(c.id) FILTER(WHERE c.account_holder_status=2)                                     quantity_consent_non_client,
            t.org_id::varchar                                                                       itp_org_id,
            case 
              WHEN c.tp_modality_payment = 1 THEN 'IMMEDIATE'
              WHEN c.tp_modality_payment = 2 THEN 'SCHEDULED'
              WHEN c.tp_modality_payment = 3 THEN 'VRP'
              WHEN c.tp_modality_payment = 4 THEN 'SWEEPING'
              WHEN c.tp_modality_payment = 5 THEN 'AUTOMATIC'
              ELSE 'RECURRENT'
            END                                                                                     product,
            CASE
              WHEN c.id_enrollment IS NOT NULL THEN 'FIDO_FLOW'
              ELSE 'HYBRID_FLOW'
            END                                                                                     authorisation_flow
          FROM consent c
            INNER JOIN tpp t ON c.id_tpp = t.id
          WHERE c.dt_creation BETWEEN start_date_utc AND end_date_utc
            AND c.tp_consent = 2
            AND c.tp_modality_payment IN (1,2)
          GROUP BY itp, t.org_id, product, authorisation_flow) subquery
          GROUP BY subquery.itp, subquery.product, subquery.authorisation_flow
          ORDER BY subquery.itp ASC, subquery.product ASC, subquery.authorisation_flow ASC;
    END IF;
END;
$function$ LANGUAGE plpgsql;