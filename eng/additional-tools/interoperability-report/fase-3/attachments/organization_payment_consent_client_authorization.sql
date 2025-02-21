CREATE OR REPLACE FUNCTION organization_payment_consent_client_authorization(
    p_start_date   DATE,
    p_end_date     DATE,
    p_is_automatic BOOLEAN,
    p_dblink_conn  TEXT
)
RETURNS TABLE(
        itp VARCHAR,
        qty_client_authentication BIGINT,
        qty_client_authorization  BIGINT)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.itp, 
        CAST(SUM(tb1.qty_client_authentication) AS bigint) AS qty_client_authentication, 
        CAST(SUM(tb1.qty_client_authorization) AS bigint) AS qty_client_authorization
    FROM (
    -- Fetch data from local payment_consent_client_authorization function
        SELECT * 
        FROM payment_consent_client_authorization(p_start_date, p_end_date, p_is_automatic)

        UNION ALL

        -- Fetch data from remote payment_consent_client_authorization function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM payment_consent_client_authorization(%L, %L, %L)',
            p_start_date,
            p_end_date,
            p_is_automatic
            )
            ) AS t(
                itp VARCHAR,
                qty_client_authentication BIGINT,
                qty_client_authorization  BIGINT
            )
        ) AS tb1
    GROUP BY 
        tb1.itp
    ORDER BY 
        tb1.itp asc;
END;
$$ LANGUAGE plpgsql;
