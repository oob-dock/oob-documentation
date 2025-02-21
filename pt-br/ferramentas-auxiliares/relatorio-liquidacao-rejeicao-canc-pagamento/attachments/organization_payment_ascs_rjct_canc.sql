CREATE OR REPLACE FUNCTION organization_payment_ascs_rjct_canc(
    p_start_date   DATE,
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE(
        org_id 				VARCHAR,
        "date" 				DATE,
        "event"				TEXT,
        product 			TEXT,
        authorizationFlow 	TEXT,
        nfcPix				TEXT,
        qty					BIGINT,
        value				NUMERIC)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.org_id,
        tb1."date",
        tb1."event",
        tb1.product,
        tb1.authorizationFlow,
        tb1.nfcPix,
        CAST(SUM(tb1.qty) AS bigint) AS qty,
        CAST(SUM(tb1.value) AS NUMERIC) AS value
    FROM (
    -- Fetch data from local payment_ascs_rjct_canc function
        SELECT * 
        FROM payment_ascs_rjct_canc(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote payment_ascs_rjct_canc function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM payment_ascs_rjct_canc(%L, %L)',
            p_start_date,
            p_end_date
            )
            ) AS t(
                org_id 				VARCHAR,
                "date" 				DATE,
                "event"				TEXT,
                product 			TEXT,
                authorizationFlow 	TEXT,
                nfcPix				TEXT,
                qty					BIGINT,
                value				NUMERIC
            )
        ) AS tb1
    GROUP BY 
        tb1.org_id, tb1."date", tb1."event", tb1.product, tb1.authorizationFlow, tb1.nfcPix
    ORDER BY 
        tb1.org_id, tb1."date", tb1."event", tb1.product, tb1.authorizationFlow, tb1.nfcPix;
END;
$$ LANGUAGE plpgsql;
