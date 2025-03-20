CREATE OR REPLACE FUNCTION organization_payment_rjct_reason(
    p_start_date   DATE,
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE(
        org_id 				VARCHAR,
        "date" 				DATE,
        product 			TEXT,
        authorizationFlow 	TEXT,
        nfcPix				TEXT,
        reason				TEXT,
        qty					BIGINT,
        value				NUMERIC)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.org_id,
        tb1."date",
        tb1.product,
        tb1.authorizationFlow,
        tb1.nfcPix,
        tb1.reason,
        CAST(SUM(tb1.qty) AS bigint) AS qty,
        CAST(SUM(tb1.value) AS NUMERIC) AS value
    FROM (
    -- Fetch data from local payment_rjct_reason function
        SELECT * 
        FROM payment_rjct_reason(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote payment_rjct_reason function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM payment_rjct_reason(%L, %L)',
            p_start_date,
            p_end_date
            )
            ) AS t(
                org_id 				VARCHAR,
                "date" 				DATE,
                product 			TEXT,
                authorizationFlow 	TEXT,
                nfcPix				TEXT,
                reason				TEXT,
                qty					BIGINT,
                value				NUMERIC
            )
        ) AS tb1
    GROUP BY 
        tb1.org_id, tb1."date", tb1.product, tb1.authorizationFlow, tb1.nfcPix, tb1.reason
    ORDER BY 
        tb1.org_id, tb1."date", tb1.product, tb1.authorizationFlow, tb1.nfcPix, tb1.reason;
END;
$$ LANGUAGE plpgsql;
