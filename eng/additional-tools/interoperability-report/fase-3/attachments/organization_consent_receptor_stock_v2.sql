CREATE OR REPLACE FUNCTION organization_consent_receptor_stock_v2(
    dt_end date,
    p_dblink_conn  TEXT
)
RETURNS TABLE (
        org_name VARCHAR,
        qtd_Estoque_Consentimentos_Ativos BIGINT,
        org_id VARCHAR
)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.org_name,
        cast(sum(tb1.qtd_Estoque_Consentimentos_Ativos) as BIGINT) as qtd_Estoque_Consentimentos_Ativos_Total,
        tb1.org_id
    FROM (
    -- Fetch data from local consent_receptor_stock function
        SELECT * 
        FROM consent_receptor_stock_v2(dt_end)

        UNION ALL

        -- Fetch data from remote consent_receptor_stock function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM consent_receptor_stock_v2(%L)',
            dt_end)) 
        AS t(
            org_name VARCHAR,
            qtd_Estoque_Consentimentos_Ativos BIGINT,
            org_id VARCHAR)) AS tb1
            
        group by tb1.org_name, tb1.org_id
        order by tb1.org_name asc;
END;
$$ LANGUAGE plpgsql;
