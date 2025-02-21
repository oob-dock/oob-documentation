CREATE OR REPLACE FUNCTION organization_payment_consent_count(
    p_start_date   DATE,
    p_end_date     DATE,
    p_is_automatic BOOLEAN,
    p_dblink_conn  TEXT
)
RETURNS TABLE (
    itp                   	     TEXT,
    quantity_request             BIGINT,
    quantity_consent_client      BIGINT,
    quantity_consent_non_client  BIGINT,
    itp_org_id					 TEXT,
    product                      TEXT,
    authorisation_flow           TEXT
)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.itp,
        CAST(SUM(tb1.quantity_request) AS BIGINT) AS quantity_request, 
        CAST(SUM(tb1.quantity_consent_client) AS BIGINT) AS quantity_consent_client, 
        CAST(SUM(tb1.quantity_consent_non_client) AS BIGINT) AS quantity_consent_non_client, 
        tb1.itp_org_id,
        tb1.product,
        tb1.authorisation_flow
    FROM (
    -- Fetch data from local payment_consent_count function
        SELECT * 
        FROM payment_consent_count(p_start_date, p_end_date, p_is_automatic)

        UNION ALL

        -- Fetch data from remote payment_consent_count function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM payment_consent_count(%L, %L, %L)',
            p_start_date,
            p_end_date,
            p_is_automatic
            )
            ) AS t(
            itp                   	     TEXT,
            quantity_request             BIGINT,
            quantity_consent_client      BIGINT,
            quantity_consent_non_client  BIGINT,
            itp_org_id					 TEXT,
            product                      TEXT,
            authorisation_flow           TEXT)) AS tb1
    GROUP BY 
        tb1.itp, 
        tb1.itp_org_id,
        tb1.product,
        tb1.authorisation_flow
    ORDER BY 
        tb1.itp ASC,
        tb1.product ASC,
        SUM(tb1.quantity_request) DESC;
END;
$$ LANGUAGE plpgsql;
