CREATE OR REPLACE FUNCTION consent_receptor_stock(dt_end date, consent_list varchar[])
    RETURNS TABLE (
        org_name VARCHAR,
        qtd_Estoque_Consentimentos_Ativos BIGINT,
        org_id VARCHAR
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
	    select  get_conglomerate_name(tpp.org_name) AS org_name,
	            count(distinct(c.id))               AS qtd_Estoque_Consentimentos_Ativos,
	            tpp.org_id 			            	AS org_id
	    from consent c
	        inner join tpp on tpp.id = c.id_tpp
	        inner join history_status hs on hs.id_consent = c.id
	    where c.id = any(consent_uuids) and c.tp_consent = 1 and c.dt_creation <= dt_end_utc and (c.dt_expiration is null or c.dt_expiration >= dt_end_utc) and c.status in (1,4,5)
	        and exists (select 1 from history_status hs where hs.id_consent = c.id and hs.status_consent = 1)
	        and not exists (select 1 from history_status hs2 where hs2.id_consent = c.id and hs2.status_consent = 4 and hs2.updated_on <= dt_end_utc)
	        group by org_name, org_id;
end;$function$;