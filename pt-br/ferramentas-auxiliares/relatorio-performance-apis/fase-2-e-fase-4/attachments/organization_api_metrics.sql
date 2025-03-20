CREATE OR REPLACE FUNCTION organization_api_metrics(
    p_start_date   DATE,
    p_end_date     DATE,
    p_dblink_conn  TEXT
)
RETURNS TABLE(
        metric_date	     		date,
		method					text,
		uri						text,
		availability_rate       numeric,
		downtime_seconds		integer,
		planned_downtime		integer,
		total_requests			integer,
		total_error				integer,
		total_rejections		integer,
		avg_tps					numeric,
		peak_tps				numeric)
AS $$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    SELECT 
        tb1.metric_date,
        tb1.method,
        tb1.uri,
        cast(max(tb1.availability_rate) as numeric) as availability_rate,
        cast(sum(tb1.downtime_seconds) as integer) as downtime_seconds,
        cast(max(tb1.planned_downtime) as integer) as planned_downtime,
        CAST(SUM(tb1.total_requests) AS integer) AS total_requests,
        CAST(SUM(tb1.total_error) AS integer) AS total_error,
        CAST(SUM(tb1.total_rejections) AS integer) AS total_rejections,
        cast(max(tb1.avg_tps) as numeric) as avg_tps,
        cast(max(tb1.peak_tps) as numeric) as peak_tps
    FROM (
    -- Fetch data from local api_metrics function
        SELECT * 
        FROM api_metrics(p_start_date, p_end_date)

        UNION ALL

        -- Fetch data from remote api_metrics function via dblink
        SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM api_metrics(%L, %L)',
            p_start_date,
            p_end_date
            )
            ) AS t(
                metric_date	     		date,
                method					text,
                uri						text,
                availability_rate       numeric,
                downtime_seconds		integer,
                planned_downtime		integer,
                total_requests			integer,
                total_error				integer,
                total_rejections		integer,
                avg_tps					numeric,
                peak_tps				numeric
            )
        ) AS tb1
    GROUP BY 
        tb1.metric_date, tb1.uri, tb1.method
    ORDER BY 
        tb1.metric_date, tb1.uri, tb1.method;
END;
$$ LANGUAGE plpgsql;
