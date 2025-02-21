CREATE OR REPLACE FUNCTION organization_extract_report_data(
    p_start_date   DATE,
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE (
    organisation_name text,
    qtd_auth_nao_iniciada int,
    qtd_auth_codes int,
    qtd_redirects int,
    qtd_redirects_receptor int
)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.organisation_name,
        CAST(SUM(tb1.qtd_auth_nao_iniciada) AS int) AS qtd_auth_nao_iniciada, 
        CAST(SUM(tb1.qtd_auth_codes) AS int) AS qtd_auth_codes, 
        CAST(SUM(tb1.qtd_redirects) AS int) AS qtd_redirects, 
        CAST(SUM(tb1.qtd_redirects_receptor) AS int) AS qtd_redirects_receptor
    FROM (
    -- Fetch data from local payment_consent_count function
        SELECT * 
        FROM extract_report_data(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote payment_consent_count function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM extract_report_data(%L, %L)',
            p_start_date,
            p_end_date)) 
        AS t(
            organisation_name text,
            qtd_auth_nao_iniciada int,
            qtd_auth_codes int,
            qtd_redirects int,
            qtd_redirects_receptor int)) AS tb1
    GROUP BY 
        tb1.organisation_name
    ORDER BY 
        tb1.organisation_name ASC;
END;
$$ LANGUAGE plpgsql;
