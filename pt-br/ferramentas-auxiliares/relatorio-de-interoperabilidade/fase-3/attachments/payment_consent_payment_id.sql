CREATE OR REPLACE FUNCTION payment_consent_payment_id(start_date DATE, end_date DATE, is_automatic boolean)
    RETURNS TABLE
            (
                itp                             TEXT,
                quantity_request                BIGINT,
                quantity_payment_id             BIGINT,
                quantity_completed_payment_id	BIGINT,
                quantity_schedule_payment_id    BIGINT,
                product                         TEXT,
                authorisation_flow              TEXT
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
            SELECT get_conglomerate_name(t.org_name::TEXT)                                    AS itp,
                    count(pr.id)                                                              AS quantity_request,
                    count(distinct cti.nm_openbanking_id)                                     AS quantity_payment_id,
                    count(distinct cti.nm_openbanking_id) FILTER (where p.payment_status = 7) AS quantity_completed_payment_id,
                    count(distinct cti.nm_openbanking_id) FILTER (where p.payment_status = 9) AS quantity_schedule_payment_id,
                    NULL                                                                      AS product,
                    NULL                                                                      AS authorisation_flow
            FROM consent c
            LEFT JOIN tpp t ON c.id_tpp = t.id  
            LEFT JOIN payment_request pr ON c.id = pr.id_consent  
            LEFT JOIN payment p ON pr.id = p.id_payment_request  
            LEFT JOIN consent_translation_id cti  on (pr.id_consent = cti.id_consent and cti.tp_openbanking_id = 8)
            WHERE ((c.dt_creation BETWEEN start_date_utc AND end_date_utc) OR (pr.dt_payment_request BETWEEN start_date_utc AND end_date_utc))
              AND c.tp_consent = 2
              AND c.tp_modality_payment IN (3,4,5)
            GROUP BY itp
            ORDER BY itp ASC, quantity_request DESC;
    ELSE
        RETURN QUERY
            select get_conglomerate_name(t.org_name::TEXT)                                AS itp,
                count(pr.id)                                                              AS quantity_request,
                count(distinct cti.nm_openbanking_id)                                     AS quantity_payment_id,
                count(distinct cti.nm_openbanking_id) FILTER (where p.payment_status = 7) AS quantity_completed_payment_id,
                count(distinct cti.nm_openbanking_id) FILTER (where p.payment_status = 9) AS quantity_schedule_payment_id,
              case
                WHEN c.tp_modality_payment = 1 THEN 'IMMEDIATE'
                WHEN c.tp_modality_payment = 2 THEN 'SCHEDULED'
                WHEN c.tp_modality_payment = 3 THEN 'VRP'
                WHEN c.tp_modality_payment = 4 THEN 'SWEEPING'
                WHEN c.tp_modality_payment = 5 THEN 'AUTOMATIC'
                ELSE 'RECURRENT'
              END                                                               			    AS product,
              case
                WHEN c.id_enrollment IS NOT NULL THEN 'FIDO_FLOW'
                ELSE 'HYBRID_FLOW'
              END                                                                         AS authorisation_flow
        FROM consent c
        LEFT JOIN tpp t ON c.id_tpp = t.id  
        LEFT JOIN payment_request pr ON c.id = pr.id_consent  
        LEFT JOIN payment p ON pr.id = p.id_payment_request  
        LEFT JOIN consent_translation_id cti  on (pr.id_consent = cti.id_consent and cti.tp_openbanking_id = 8)
        WHERE ((c.dt_creation BETWEEN start_date_utc AND end_date_utc) OR (pr.dt_payment_request BETWEEN start_date_utc AND end_date_utc))
          AND c.tp_consent = 2
          AND c.tp_modality_payment IN (1,2)
        GROUP BY itp, c.tp_modality_payment, authorisation_flow
        ORDER BY itp ASC, product ASC, authorisation_flow ASC;
    END IF;
END;
$function$ LANGUAGE plpgsql;