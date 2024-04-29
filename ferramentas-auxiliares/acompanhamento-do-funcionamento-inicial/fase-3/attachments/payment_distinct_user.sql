create or replace function payment_distinct_user(dt_start date, dt_end date)
	returns table (
		qty_distinct_cpf			BIGINT,
		qty_distinct_cnpj			BIGINT
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
			count(distinct(c.sha_person_document_number)) as qty_distinct_cpf,
			count(distinct(c.sha_business_document_number)) as qty_distinct_cnpj
		from consent c  
			where c.dt_creation between dt_start_utc and dt_end_utc
			and c.tp_consent = 2
			and exists (select 1 from history_status hs where hs.id_consent = c.id and hs.status_consent = 1);
end;$function$;