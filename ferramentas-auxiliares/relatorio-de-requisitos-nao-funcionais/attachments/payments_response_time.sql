create or replace function public.payments_response_time(dt_end date)
 returns table(organizacao uuid, data_metrica date, periodo text, metodo_http text, endpoint text, menos_um_meio_segundos int8, mais_um_meio_segundos int8)
 language plpgsql
as $function$
declare dt_initial_interval varchar;
declare dt_end_interval varchar;
begin
	select (dt_end - INTERVAL '6 days')::varchar INTO dt_initial_interval;
	select (dt_end + INTERVAL '1 days')::varchar INTO dt_end_interval;
	
   	return query
	   	with endpoints as (
			select
				r.server_org_id,
				case
					when r.event_data#>>'{endpoint}' like '%/payments/v%/consents' then REGEXP_REPLACE(r.event_data#>>'{endpoint}', '(.*)/payments/v(.*)/consents', 'payments/v\2/consents')
					when r.event_data#>>'{endpoint}' like '%/payments/v%/consents/%' then REGEXP_REPLACE(r.event_data#>>'{endpoint}', '(.*)/payments/v(.*)/consents/.*', 'payments/v\2/consents/consentId')
					when r.event_data#>>'{endpoint}' like '%/payments/v%/pix/payments' then REGEXP_REPLACE(r.event_data#>>'{endpoint}', '(.*)/payments/v(.*)/pix/payments', 'payments/v\2/pix/payments')
					when r.event_data#>>'{endpoint}' like '%/payments/v%/pix/payments/%' then REGEXP_REPLACE(r.event_data#>>'{endpoint}', '(.*)/payments/v(.*)/pix/payments/.*', 'payments/v\2/pix/payments/paymentId')
				end endpoint,
				r.event_data->>'httpMethod' as httpMethod,
				(r.event_data->>'processTimespan')::numeric as processTimespan,
				r.event_timestamp::date as measure_date
				from report r
				where
					event_data->>'endpoint' like '/open-banking/payments%' and
					event_data->>'role' = 'SERVER' and
					event_timestamp between dt_initial_interval and dt_end_interval and
					event_data->>'statusCode' not in ('423', '429', '529')
		)
		select 
			e.server_org_id as organizacao,
			e.measure_date as data_metrica,
			case
				when date_part('isodow', e.measure_date) = 1 then 'Segunda-feira'
				when date_part('isodow', e.measure_date) = 2 then 'Terça-feira'
				when date_part('isodow', e.measure_date) = 3 then 'Quarta-feira'
				when date_part('isodow', e.measure_date) = 4 then 'Quinta-feira'
				when date_part('isodow', e.measure_date) = 5 then 'Sexta-feira'
				when date_part('isodow', e.measure_date) = 6 then 'Sábado'
				when date_part('isodow', e.measure_date) = 7 then 'Domingo'
			end periodo,
			e.httpMethod as metodo_http,
			e.endpoint,
			count (*) filter (where e.processTimespan <= 1500) as menos_um_meio_segundos,
			count (*) filter (where e.processTimespan > 1500) as mais_um_meio_segundos
		from endpoints e
		group by e.server_org_id, e.endpoint, e.measure_date, e.httpMethod
		order by e.measure_date;
end;$function$;