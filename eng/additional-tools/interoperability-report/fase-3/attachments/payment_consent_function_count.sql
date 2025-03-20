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

                RETURN QUERY 
                  SELECT t.org_name::TEXT                                                                   itp,
                    count(c.id)                                                                             quantity_request,
                    count(c.id) FILTER(WHERE c.account_holder_status=1  or c.account_holder_status is null) quantity_consent_client,
                    count(c.id) FILTER(WHERE c.account_holder_status=2)                                     quantity_consent_non_client,
                    t.org_id::TEXT                                                                          itp_org_id,
                    case
                      WHEN c.tp_modality_payment = 1 THEN 'IMMEDIATE'
                      WHEN c.tp_modality_payment = 2 THEN 'SCHEDULED'
                      ELSE 'RECURRENT'
                    END AS product,
                    CASE 
                      WHEN c.id_enrollment IS NOT NULL THEN 'FIDO_FLOW'
                      ELSE 'HYBRID_FLOW'
                    END AS  authorisation_flow
                  FROM consent c
                    INNER JOIN tpp t ON c.id_tpp = t.id
                  WHERE c.dt_creation BETWEEN start_date_utc AND end_date_utc
                    AND c.tp_consent = 2
                    AND ((is_automatic is false AND c.tp_modality_payment IN (1,2)) OR (is_automatic is true AND c.tp_modality_payment IN (3,4,5)))
                  GROUP BY t.org_name, t.org_id, c.tp_modality_payment, authorisation_flow
                  ORDER BY t.org_name ASC, product ASC, quantity_request DESC;
END;
$function$ LANGUAGE plpgsql;