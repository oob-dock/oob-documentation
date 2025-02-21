CREATE OR REPLACE FUNCTION organization_payment_async_validation(
    p_start_date   DATE,
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE(
        itp						VARCHAR,
		itp_id					VARCHAR,
		api						TEXT,
		endpoint				TEXT,
		endpoint_uri 			TEXT,
		method					TEXT,
		rejection_reason		TEXT,
		qty_requests			BIGINT)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.itp,
        tb1.itp_id,
        tb1.api,
        tb1.endpoint,
        tb1.endpoint_uri,
        tb1.method,
        tb1.rejection_reason,
        CAST(SUM(tb1.qty_requests) AS bigint) AS qty_requests
    FROM (
    -- Fetch data from local payment_async_validation function
        SELECT * 
        FROM payment_async_validation(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote payment_async_validation function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM payment_async_validation(%L, %L)',
            p_start_date,
            p_end_date
            )
            ) AS t(
                itp						VARCHAR,
                itp_id					VARCHAR,
                api						TEXT,
                endpoint				TEXT,
                endpoint_uri 			TEXT,
                method					TEXT,
                rejection_reason		TEXT,
                qty_requests			BIGINT
            )
        ) AS tb1
    GROUP BY 
        tb1.itp, tb1.itp_id, tb1.api, tb1.endpoint, tb1.endpoint_uri, tb1.method, tb1.rejection_reason
    ORDER BY 
        tb1.itp asc, tb1.api, tb1.endpoint, tb1.endpoint_uri, tb1.method;
END;
$$ LANGUAGE plpgsql;
