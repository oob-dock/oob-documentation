CREATE OR REPLACE FUNCTION organization_consent_consolidated_stock(
    dt_end date,
    consent_list varchar[],
    p_dblink_conn  TEXT
)
RETURNS TABLE (
        Clientes_Unicos_PF_Total BIGINT,
        Clientes_Unicos_PJ_Total BIGINT
)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        count(distinct(tb1.Clientes_Unicos_PF)) 		as Clientes_Unicos_PF_Total,
        count(distinct(tb1.Clientes_Unicos_PJ)) 		as Clientes_Unicos_PJ_Total
    FROM (
    -- Fetch data from local payment_consent_count function
        SELECT * 
        FROM consent_stock(dt_end, consent_list)

        UNION ALL

        -- Fetch data from remote payment_consent_count function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM consent_stock(%L, %L)',
            dt_end,
            consent_list)) 
        AS t(
            Clientes_Unicos_PF TEXT,
            Clientes_Unicos_PJ TEXT)) AS tb1;
END;
$$ LANGUAGE plpgsql;
