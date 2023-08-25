CREATE OR REPLACE FUNCTION public.status_function_availability (dt_end DATE) RETURNS TABLE (
  endpoint varchar(200),
  data_metrica TEXT,
  periodo TEXT,
  percentual_disponibilidade NUMERIC(5, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  WITH availability AS
  (
  	SELECT
    e.endpoint_url as endpoint,
    metric_date,
    seconds_downtime    	
	 FROM
	    daily_metric_endpoint d
	 INNER JOIN endpoint e on e.id = d.id_endpoint
	 WHERE endpoint_url like '/payment%'
	 AND metric_date >= dt_end - interval '89 days'
	 AND metric_date <= dt_end
  )
  (
  	SELECT
     a.endpoint,
     to_char(dt_end - interval '89 days', 'YYYY-MM-DD') || ' - ' || to_char( dt_end, 'YYYY-MM-DD') as data_metrica,
     'Últimos três meses' AS periodo,
     (((7776000 - sum(a.seconds_downtime)) / 7776000.00) * 100)::numeric(5, 2) AS percentual_disponibilidade
	 FROM
	    availability a
	 GROUP BY
	   a.endpoint,
       data_metrica,
	   periodo
  )
  UNION ALL
  (
  	SELECT
    a.endpoint,
    to_char( metric_date, 'YYYY-MM-DD') as data_metrica,
    CASE
	   WHEN extract(DOW FROM metric_date) = 0 THEN 'Domingo'
	   WHEN extract(DOW FROM metric_date) = 1 THEN 'Segunda-feira'
	   WHEN extract(DOW FROM metric_date) = 2 THEN 'Terça-feira'
	   WHEN extract(DOW FROM metric_date) = 3 THEN 'Quarta-feira'
	   WHEN extract(DOW FROM metric_date) = 4 THEN 'Quinta-feira'
	   WHEN extract(DOW FROM metric_date) = 5 THEN 'Sexta-feira'
	   WHEN extract(DOW FROM metric_date) = 6 THEN 'Sábado'
	 end AS periodo,
     (((86400 - seconds_downtime) / 86400.00) * 100)::numeric(5, 2) AS percentual_disponibilidade
	 FROM
	    availability a
	 WHERE metric_date >= dt_end - interval '6 days'
	 GROUP BY
	   a.endpoint,
	   periodo,
	   metric_date,
	   percentual_disponibilidade
	 order by metric_date desc
  )
  UNION ALL
  (
  	SELECT
    '/auth/auth/token',
    to_char( dt::date, 'YYYY-MM-DD') as data_metrica,
    CASE
       WHEN extract(DOW FROM dt::date) = 0 THEN 'Domingo'
       WHEN extract(DOW FROM dt::date ) = 1 THEN 'Segunda-feira'
       WHEN extract(DOW FROM dt::date ) = 2 THEN 'Terça-feira'
       WHEN extract(DOW FROM dt::date ) = 3 THEN 'Quarta-feira'
       WHEN extract(DOW FROM dt::date ) = 4 THEN 'Quinta-feira'
       WHEN extract(DOW FROM dt::date ) = 5 THEN 'Sexta-feira'
       WHEN extract(DOW FROM dt::date ) = 6 THEN 'Sábado'
     end AS periodo,
     100 as percentual_disponibilidade
     FROM generate_series(dt_end - interval '6 days', dt_end, interval '1 days') dt
     order by dt::date desc
  );
END;
$$;