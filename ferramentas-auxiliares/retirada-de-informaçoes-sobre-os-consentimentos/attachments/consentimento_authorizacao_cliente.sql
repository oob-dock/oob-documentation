CREATE OR REPLACE FUNCTION consentimento_authorizacao_cliente(dt_start date, dt_end date)
    RETURNS TABLE (
        org_name VARCHAR,
        qtd_auth_cliente INT8
)
LANGUAGE plpgsql
AS $function$
DECLARE dt_start_utc timestamptz;
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
BEGIN

	select dt_end + interval '1 day' into dt_end_interval;
	select dt_start::date::timestamp AT TIME ZONE 'UTC' into dt_start_utc;
	select dt_end_interval::date::timestamp AT TIME ZONE 'UTC' into dt_end_utc;

	return QUERY
	select	t.org_name,
			count(c.id) Qtd_Auth_Cliente
	from 	consent c, 
			tpp t 
	where 	c.dt_creation between dt_start and dt_end
	and 	c.status in (1,4,5)
	and 	c.tp_consent = 1
	and		c.id_tpp = t.id 
	group by t.org_name;

END;$function$;