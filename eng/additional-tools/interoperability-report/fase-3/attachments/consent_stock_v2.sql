CREATE OR REPLACE FUNCTION public.consent_stock_v2(dt_end date)
 RETURNS TABLE (
    clientes_unicos_pf varchar(200),
    clientes_unicos_pj varchar(200))
 LANGUAGE plpgsql
AS $function$
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
BEGIN
    SELECT dt_end + INTERVAL '1 day' INTO dt_end_interval;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'America/Sao_Paulo' INTO dt_end_utc;

    RETURN QUERY
        select c.sha_person_document_number	  as Clientes_Unicos_PF,
		       c.sha_business_document_number as Clientes_Unicos_PJ
		from consent c
		where c.tp_consent = 1
        and c.status = 1
        and c.dt_creation < dt_end_utc
        and (c.dt_expiration is null or c.dt_expiration > dt_end_utc)
        group by c.sha_person_document_number, c.sha_business_document_number;
END;$function$
;