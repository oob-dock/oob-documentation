CREATE OR REPLACE FUNCTION organization_consent_authorization_client(p_start_date date, p_end_date date, p_dblink_conn text)
 RETURNS TABLE(org_name character varying, qtd_auth_cliente bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.org_name,
        CAST(SUM(tb1.qtd_auth_cliente) AS INT8) AS qtd_auth_cliente
    FROM (
    -- Fetch data from local payment_consent_count function
        SELECT * 
        FROM consent_authorization_client(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote payment_consent_count function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM consent_authorization_client(%L, %L)',
            p_start_date,
            p_end_date)) 
        AS t(
            org_name VARCHAR,
            qtd_auth_cliente INT8)) AS tb1
    GROUP BY 
        tb1.org_name
    ORDER BY 
        tb1.org_name ASC;
END;
$function$
;
