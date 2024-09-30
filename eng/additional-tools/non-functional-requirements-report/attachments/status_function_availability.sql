CREATE OR REPLACE FUNCTION status_function_availability (dt_end DATE) RETURNS TABLE (
  http_method TEXT,
  endpoint varchar(200),
  metric_date TEXT,
  period TEXT,
  availability_percentage NUMERIC(5, 2)
)
LANGUAGE plpgsql
AS $$
begin  
  RETURN QUERY
  WITH availability AS
  (
  	select
  	split_part(substring(e.endpoint_name , '[_-](GET|POST|PATCH|DELETE)'), '-', 1) as http_method,
    e.endpoint_url as endpoint,
    metric_date,
    seconds_downtime
	 FROM
	    daily_metric_endpoint d
	 INNER JOIN endpoint e on e.id = d.id_endpoint
	 WHERE endpoint_url like '/payment%' or (dt_end > '2024-04-29' and endpoint_url like '/automatic-payment%')
	 AND metric_date >= dt_end - interval '89 days'
	 AND metric_date <= dt_end
  )
  (
  	select
     a.http_method,
     a.endpoint,
     to_char(dt_end - interval '89 days', 'YYYY-MM-DD') || ' - ' || to_char( dt_end, 'YYYY-MM-DD') as metric_date,
     'Last three months' AS period,
     (((7776000 - sum(a.seconds_downtime)) / 7776000.00) * 100)::numeric(5, 2) AS availability_percentage
	 FROM
	    availability a
	 GROUP by
	   a.http_method,
	   a.endpoint,
       metric_date,
	   period
  )
  UNION ALL
  (
  	select
  	a.http_method,
    a.endpoint,
    to_char( metric_date, 'YYYY-MM-DD') as metric_date,
    CASE
       WHEN extract(DOW FROM metric_date) = 0 THEN 'Sunday'
       WHEN extract(DOW FROM metric_date ) = 1 THEN 'Monday'
       WHEN extract(DOW FROM metric_date ) = 2 THEN 'Tuesday'
       WHEN extract(DOW FROM metric_date ) = 3 THEN 'Wednesday'
       WHEN extract(DOW FROM metric_date ) = 4 THEN 'Thursday'
       WHEN extract(DOW FROM metric_date ) = 5 THEN 'Friday'
       WHEN extract(DOW FROM metric_date ) = 6 THEN 'Saturday'
	 end AS period,
     (((86400 - seconds_downtime) / 86400.00) * 100)::numeric(5, 2) AS availability_percentage
	 FROM
	    availability a
	 WHERE metric_date >= dt_end - interval '6 days'
	 GROUP by
       a.http_method,
	   a.endpoint,
	   period,
	   metric_date,
	   availability_percentage
	 order by metric_date desc
  )
  UNION ALL
  (
  	select
  	'POST',
    '/auth/auth/token',
    CASE
	   WHEN dt::date = dt_end - interval '7 days' THEN  to_char(dt_end - interval '89 days', 'YYYY-MM-DD') || ' - ' || to_char( dt_end, 'YYYY-MM-DD')
	   else to_char( dt::date, 'YYYY-MM-DD')
    end  as metric_date,
    CASE
	   WHEN dt::date = dt_end - interval '7 days' THEN 'Last three months'
       WHEN extract(DOW FROM dt::date) = 0 THEN 'Sunday'
       WHEN extract(DOW FROM dt::date ) = 1 THEN 'Monday'
       WHEN extract(DOW FROM dt::date ) = 2 THEN 'Tuesday'
       WHEN extract(DOW FROM dt::date ) = 3 THEN 'Wednesday'
       WHEN extract(DOW FROM dt::date ) = 4 THEN 'Thursday'
       WHEN extract(DOW FROM dt::date ) = 5 THEN 'Friday'
       WHEN extract(DOW FROM dt::date ) = 6 THEN 'Saturday'
     end AS period,
     100 as availability_percentage
     FROM generate_series(dt_end - interval '7 days', dt_end, interval '1 day') dt
     order by dt::date desc
  );
END;
$$;