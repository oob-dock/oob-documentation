CREATE OR REPLACE FUNCTION organization_consent_usage_report(
    p_start_date   DATE,
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE (
    receptor             TEXT,
    quantity_client      BIGINT,
    quantity_non_client  BIGINT,
    receptor_org_id	     TEXT
)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.receptor,
        CAST(SUM(tb1.quantity_client) AS BIGINT) AS quantity_client, 
        CAST(SUM(tb1.quantity_non_client) AS BIGINT) AS quantity_non_client, 
        tb1.receptor_org_id
    FROM (
    -- Fetch data from local payment_consent_count function
        SELECT * 
        FROM consent_usage_report(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote payment_consent_count function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM consent_usage_report(%L, %L)',
            p_start_date,
            p_end_date)) 
        AS t(
            receptor             TEXT,
            quantity_client      BIGINT,
            quantity_non_client  BIGINT,
            receptor_org_id	     TEXT)) AS tb1
    GROUP BY 
        tb1.receptor, 
        tb1.receptor_org_id
    ORDER BY 
        tb1.receptor ASC,
        tb1.receptor_org_id ASC;
END;
$$ LANGUAGE plpgsql;
