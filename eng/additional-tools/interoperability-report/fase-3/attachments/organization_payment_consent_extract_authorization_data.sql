    CREATE OR REPLACE FUNCTION organization_payment_consent_extract_authorization_data(
        p_start_date                 DATE,
        p_end_date                   DATE,
        p_is_automatic               BOOLEAN,
        p_dblink_conn_local_consent  TEXT,
        p_dblink_conn_remote_as      TEXT,
        p_dblink_conn_remote_consent TEXT
    )
    RETURNS TABLE(
        itp text, 
        qty_auth_initiated int, 
        qty_auth_codes int, 
        qty_auth_redirects_itp int, 
        qty_access_token int, 
        product text, 
        authorisation_flow text)
    AS $$
    BEGIN
    -- Return the aggregated payment consent summary
    RETURN QUERY
        SELECT 
            tb1.itp, 
            CAST(SUM(tb1.qty_auth_initiated) AS int) AS qty_auth_initiated, 
            CAST(SUM(tb1.qty_auth_codes) AS int) AS qty_auth_codes, 
            CAST(SUM(tb1.qty_auth_redirects_itp) AS int) AS qty_auth_redirects_itp, 
            CAST(SUM(tb1.qty_access_token) AS int) AS qty_access_token,
            tb1.product AS product,
            tb1.authorisation_flow AS authorisation_flow
        FROM (
        -- Fetch data from local payment_consent_extract_authorization_data function
            SELECT * 
            FROM payment_consent_extract_authorization_data(p_start_date, p_end_date, p_is_automatic, p_dblink_conn_local_consent)

            UNION ALL

            -- Fetch data from remote payment_consent_extract_authorization_data function via dblink
            SELECT * 
            FROM dblink(
                p_dblink_conn_remote_as,
                FORMAT(
                'SELECT * FROM payment_consent_extract_authorization_data(%L, %L, %L, %L)',
                p_start_date,
                p_end_date,
                p_is_automatic,
                p_dblink_conn_remote_consent
                )
                ) AS t(
                    itp text, 
                    qty_auth_initiated int, 
                    qty_auth_codes int, 
                    qty_auth_redirects_itp int, 
                    qty_access_token int, 
                    product text, 
                    authorisation_flow text
                )
            ) AS tb1
        GROUP BY 
            tb1.itp, tb1.product, tb1.authorisation_flow
        ORDER BY 
            tb1.itp asc, tb1.product asc, tb1.authorisation_flow asc;
    END;
$$ LANGUAGE plpgsql;