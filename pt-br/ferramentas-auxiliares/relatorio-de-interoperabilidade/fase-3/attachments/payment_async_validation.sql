create or replace function payment_async_validation(dt_start date, dt_end date)
	returns table (
		itp						VARCHAR,
		itp_id					VARCHAR,
		api						TEXT,
		endpoint				TEXT,
		endpoint_uri 			TEXT,
		method					TEXT,
		rejection_reason		TEXT,
		qty_requests			BIGINT
	)
language plpgsql
as $function$
declare dt_start_utc timestamptz;
declare dt_end_interval date;
declare dt_end_utc timestamptz;
begin
    select dt_end + INTERVAL '1 day' INTO dt_end_interval;
    select dt_start::date::timestamp AT TIME ZONE 'UTC' INTO dt_start_utc;
    select dt_end_interval::date::timestamp AT TIME ZONE 'UTC' INTO dt_end_utc;
   
	return query 
		with rejections as (
			select 
				t.org_name 							as itp,
				t.org_id 							as itp_id,
				'Pagamentos'						as api,
				case
					when p.rejection_reason#>>'{method}' = 'POST' then 'Pix - Criar iniciação de pagamento'
					when p.rejection_reason#>>'{method}' = 'PATCH' then 'Pix - Cancelar iniciação de pagamento'
					else 'Pix - Consultar iniciação de pagamento'
				end									as endpoint,
				p.rejection_reason->>'uri'			as endpoint_uri,
				p.rejection_reason->>'method'		as method,
				p.rejection_reason->>'code'			as rejection_reason
			from payment p
			inner join payment_request pr on p.id_payment_request = pr.id 
			inner join consent c on c.id = pr.id_consent 
			inner join tpp t on t.id = c.id_tpp
			where p.dt_creation between dt_start_utc and dt_end_utc and p.rejection_reason->'uri' is not null
		)
select r.itp, r.itp_id, r.api, r.endpoint, 
case
	when r.method::text = 'POST' then '/open-banking' || r.endpoint_uri::text
	when (r.method::text = 'GET' or r.method::text = 'PATCH') and r.endpoint_uri::text like '%recurring%' then '/open-banking' || r.endpoint_uri::text || '/{recurringPaymentId}'
	else '/open-banking' || r.endpoint_uri::text || '/{paymentId}'
end	as endpoint_uri,
r.method::text, r.rejection_reason::text, count(*) as qty from rejections r
group by r.itp, r.itp_id, r.api, r.endpoint, r.endpoint_uri, r.method, r.rejection_reason
order by r.itp asc;

end;$function$;