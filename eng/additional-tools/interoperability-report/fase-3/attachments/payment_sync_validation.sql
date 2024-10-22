create or replace function payment_sync_validation(dt_start date, dt_end date)
	returns table (
		org_id					UUID,
		itp_id					UUID,
		api						TEXT,
		endpoint				TEXT,
		status_code				TEXT,
		method					TEXT,
		endpoint_uri 			TEXT,
		error_code				TEXT,
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
		select
			r.server_org_id as org_id,
			r.client_org_id as itp_id,
			case 
				when r.event_data #>>'{endpoint}' like '/open-banking/payments/v%/pix/payments' then 'Pagamentos'
				else 'Pagamentos Automáticos'
			end as api,
			case 
				when r.event_data #>>'{endpoint}' like '/open-banking/payments/v%/pix/payments' then 'Pix - Criar iniciação de pagamento'
				else 'Cria uma transação de pagamento'
			end as endpoint,
			r.event_data#>>'{statusCode}' as status_code,
			r.event_data#>>'{httpMethod}' as "method",
			r.event_data#>>'{endpoint}' as endpoint_uri,
			r.event_data#>>'{errorCode}' as error_code,
			count(*) as qty_requests
		from report r
		where SUBSTRING(r.event_data#>>'{statusCode}' from 1 for 1) > '3' and
			r.event_role = 'SERVER' and r.event_data#>>'{httpMethod}' = 'POST' and
			(r.event_data #>>'{endpoint}' like '/open-banking/payments/v%/pix/payments' or r.event_data #>>'{endpoint}' like '/open-banking/automatic-payments/v%/pix/recurring-payments') and
			r.created_at between dt_start_utc and dt_end_utc
		group by r.server_org_id, r.client_org_id, r.event_data#>>'{httpMethod}', r.event_data#>>'{endpoint}', r.event_data#>>'{statusCode}', r.event_data#>>'{errorCode}';
end;$function$;