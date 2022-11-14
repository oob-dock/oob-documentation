CREATE OR REPLACE FUNCTION extract_report_data(dt_start date, dt_end date)
 RETURNS TABLE(organisation_name text, qtd_auth_nao_iniciada int, qtd_auth_codes int, qtd_redirects int, qtd_redirects_receptor int)
 LANGUAGE plpgsql
AS $function$

DECLARE dt_start_utc timestamptz;
declare dt_end_interval date;
DECLARE dt_end_utc timestamptz;

begin
	SELECT dt_end + interval '1 day' into dt_end_interval;
	SELECT dt_start::date::timestamp AT TIME ZONE 'UTC' into dt_start_utc;
	SELECT dt_end_interval::date::timestamp AT TIME ZONE 'UTC' into dt_end_utc;
	
	
   RETURN QUERY
   select	convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}' Organisation_Name,
        	CAST(sum(t2.qtd) AS integer) as Qtd_Auth_Nao_Iniciada,
			CAST(sum(Qtd_Codes) AS integer) as Qtd_Auth_Codes,
			CAST(sum(Qtd_Codes) AS integer) as Qtd_Redirects,
			CAST(sum(qtd_recept) AS integer) as Qtd_Redirects_Receptor
	from
		(
			select
				c.id,
				c.data,
				count(distinct consentId) as qtd
			from
				(
					with x as (
						select
							convert_from(decode_base64url(regexp_replace(data#>>'{request}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json as decoded,
							"createdAt"
						from "PushedAuthorizationRequests" par
					)
					select
						(regexp_matches(x.decoded#>>'{scope}', '(consent\:(.*?)\:(.*?)\:(.{36}))'))[1] as consentId,
						c.id
					from x,
						"Clients" c
					where
						x.decoded#>>'{scope}' like '%consent:%'
					and x.decoded#>>'{scope}' not like '%payments%'
					and x."createdAt" between dt_start_utc and dt_end_utc
					and c.id = x.decoded#>>'{client_id}'
				) t1,
				"Clients" c
			where
				t1.id = c.id
			group by
				c.id,
				c.data
		) t2,    
        (
			select 
				count(ac.*) Qtd_Codes,
				g.data#>>'{clientId}' as clientId
			from 	"AuthorizationCodes" ac , 
					"Grants" g
			where 	g."createdAt" between dt_start_utc and dt_end_utc
			and 	ac."grantId" = g.id 
			and 	g.data#>>'{openid,scope}' like '%consent:%'
			and 	g.data#>>'{openid,scope}' not like '%payments%'
			group by g.data#>>'{clientId}' 
		) as t3,
		(
			select 	count(ac.*) qtd_recept,
					g.data#>>'{clientId}' as clientId
			from 	"AuthorizationCodes" ac , 
					"Grants" g 
			where 	g."createdAt" between dt_start_utc and dt_end_utc
			and 	ac."grantId" = g.id 
			and 	ac."consumedAt" is not null
			and 	g.data#>>'{openid,scope}' like '%consent:%'
			and 	g.data#>>'{openid,scope}' not like '%payments%'
			group by g.data#>>'{clientId}'
		) as t4,
		"Clients" c
where	t2.id = c.id AND
        t3.clientId = c.id and 
		t4.clientId = c.id
group by convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}';
   
END;$function$;