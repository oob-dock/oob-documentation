CREATE OR REPLACE FUNCTION organization_status_function_availability(
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE(
        metodo_http TEXT,
        endpoint varchar(200),
        data_metrica TEXT,
        periodo TEXT,
        percentual_disponibilidade NUMERIC(5, 2))
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.metodo_http,
        tb1.endpoint,
        tb1.data_metrica,
        tb1.periodo,
        cast(max(tb1.percentual_disponibilidade) as NUMERIC(5, 2)) as percentual_disponibilidade
    FROM (
    -- Fetch data from local status_function_availability function
        SELECT * 
        FROM status_function_availability(p_end_date)

        UNION ALL

        -- Fetch data from remote status_function_availability function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM status_function_availability(%L)',
            p_end_date
            )
            ) AS t(
                metodo_http TEXT,
                endpoint varchar(200),
                data_metrica TEXT,
                periodo TEXT,
                percentual_disponibilidade NUMERIC(5, 2)
            )
        ) AS tb1
    GROUP BY 
        tb1.metodo_http, tb1.endpoint, tb1.data_metrica, tb1.periodo
    ORDER BY 
        tb1.metodo_http, tb1.endpoint, tb1.data_metrica, tb1.periodo;
END;
$$ LANGUAGE plpgsql;
