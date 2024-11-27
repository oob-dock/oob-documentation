CREATE OR REPLACE FUNCTION consent_consolidated_stock(dt_end date, consent_list varchar[])
    RETURNS TABLE (
        Clientes_Unicos_PF_Total BIGINT,
        Clientes_Unicos_PJ_Total BIGINT
)
LANGUAGE plpgsql
AS $function$
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
DECLARE consent_uuids uuid[] = cast(consent_list as uuid[]);
BEGIN
    SELECT dt_end + INTERVAL '1 day' INTO dt_end_interval;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'America/Sao_Paulo' INTO dt_end_utc;

    RETURN QUERY
        select 	count(distinct(c.sha_person_document_number)) 		as Clientes_Unicos_PF_Total,
				count(distinct(c.sha_business_document_number)) 	as 	Clientes_Unicos_PJ_Total
		from consent c
			inner join tpp on tpp.id = c.id_tpp
			inner join history_status hs on hs.id_consent = c.id
		where c.id = any(consent_uuids) and c.tp_consent = 1 and c.dt_creation <= dt_end_utc and (c.dt_expiration is null or c.dt_expiration >= dt_end_utc) and c.status in (1,4,5)
			and exists (select 1 from history_status hs where hs.id_consent = c.id and hs.status_consent = 1)
			and not exists (select 1 from history_status hs2 where hs2.id_consent = c.id and hs2.status_consent = 4 and hs2.updated_on <= dt_end_utc);
END;$function$;