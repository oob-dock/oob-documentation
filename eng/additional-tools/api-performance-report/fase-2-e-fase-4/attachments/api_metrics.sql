create or replace function api_metrics(dt_start date, dt_end date)
	returns table (
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
language plpgsql
as $function$
begin
	return query
		select 
			dme.metric_date 							    	as metric_date,
			(regexp_match(e.endpoint_name, '_([^-]+)'))[1]		as method,
			'/open-banking' || e.endpoint_url 					as uri,
		    ((86400.0 - dme.seconds_downtime) / 86400.0) * 100 	as availability_rate,
		    dme.seconds_downtime 								as downtime_seconds,
		    0													as planned_downtime, --not supported
		    dme.qty_invocations 								as total_requests,
		    dme.qty_errors 										as total_error,
		    dme.qty_rejections 									as total_rejections,
		    dme.avg_tps 										as avg_tps,
		    dme.peak_tps 										as peak_tps
		from daily_metric_endpoint dme 
		inner join endpoint e on dme.id_endpoint = e.id 
		where e.feature = 3 and dme.metric_date between dt_start and dt_end
		order by '/open-banking' || e.endpoint_url , (regexp_match(e.endpoint_name, '_([^-]+)'))[1], dme.metric_date;
end;$function$;