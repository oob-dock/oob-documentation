CREATE OR REPLACE FUNCTION payment_consent_client_authorization(dt_start date, dt_end date, is_automatic boolean)
    RETURNS TABLE (
        itp VARCHAR,
        qty_client_authentication BIGINT,
        qty_client_authorization  BIGINT
)
LANGUAGE plpgsql
AS $function$
DECLARE dt_start_utc timestamptz;
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
BEGIN
    SELECT dt_end + INTERVAL '1 day' INTO dt_end_interval;
    SELECT dt_start::date::timestamp AT TIME ZONE 'UTC' INTO dt_start_utc;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'UTC' INTO dt_end_utc;

    RETURN QUERY
        SELECT t.org_name   		 as itp,
            COUNT(distinct c.id) FILTER(WHERE c.id_enrollment is null) as qty_client_authentication,
            COUNT(distinct c.id) as qty_client_authorization
        FROM consent c
        INNER JOIN tpp t ON c.id_tpp = t.id 
        WHERE c.dt_creation BETWEEN dt_start_utc AND dt_end_utc
            AND c.tp_consent = 2
            AND ((is_automatic is false AND c.tp_modality_payment IN (1,2)) OR (is_automatic is true AND c.tp_modality_payment IN (3,4,5)))
            AND exists (select 1 from history_status hs where hs.id_consent = c.id and hs.status_consent = 1 and hs.updated_on between dt_start_utc and dt_end_utc)
        GROUP BY t.org_name;
END;$function$;