CREATE OR REPLACE FUNCTION consent_authorization_client(dt_start date, dt_end date)
    RETURNS TABLE (
        org_name VARCHAR,
        qtd_auth_cliente INT8
)
LANGUAGE plpgsql
AS $function$
DECLARE dt_start_utc timestamptz;
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
BEGIN
    SELECT dt_end + INTERVAL '1 day' INTO dt_end_interval;
    SELECT dt_start::date::timestamp AT TIME ZONE 'America/Sao_Paulo' INTO dt_start_utc;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'America/Sao_Paulo' INTO dt_end_utc;

    RETURN QUERY
        SELECT t.org_name,
            COUNT(c.id) Qtd_Auth_Cliente
        FROM consent c,
            tpp t
        WHERE c.dt_creation BETWEEN dt_start_utc AND dt_end_utc
            AND c.status IN (1, 4, 5)
            AND c.tp_consent = 1
            AND c.id_tpp = t.id
        GROUP BY t.org_name;
END;$function$;