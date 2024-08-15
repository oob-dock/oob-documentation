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
   with t1 as (
   select   c.id,
            count(distinct consentId) as Qtd_Auth_Nao_Iniciada,
            0 as Qtd_Auth_Codes,
            0 as Qtd_Redirects,
            0 as Qtd_Redirects_Receptor
    from
        (
            with x as (
                select
                    convert_from(decode_base64url(regexp_replace(data#>>'{request}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json as decoded,
                    "createdAt"
                from "PushedAuthorizationRequests" par
                where par."createdAt" between dt_start_utc and dt_end_utc
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
        c.id
    union all
            select
                g.data#>>'{clientId}' as id,
                0 as Qtd_Auth_Nao_Iniciada,
                count(ac.*) as Qtd_Auth_Codes,
                count(ac.*) as Qtd_Redirects,
                0 as Qtd_Redirects_Receptor
            from    "AuthorizationCodes" ac ,
                    "Grants" g
            where   g."createdAt" between dt_start_utc and dt_end_utc
            and     ac."grantId" = g.id
            and     g.data#>>'{openid,scope}' like '%consent:%'
            and     g.data#>>'{openid,scope}' not like '%payments%'
            group by g.data#>>'{clientId}'
    union all
            select  g.data#>>'{clientId}' as id,
                    0 as Qtd_Auth_Nao_Iniciada,
                    0 as Qtd_Auth_Codes,
                    0 as Qtd_Redirects,
                    count(ac.*) as Qtd_Redirects_Receptor
            from    "AuthorizationCodes" ac,
                    "Grants" g
            where   g."createdAt" between dt_start_utc and dt_end_utc
            and     ac."grantId" = g.id
            and     ac."consumedAt" is not null
            and     g.data#>>'{openid,scope}' like '%consent:%'
            and     g.data#>>'{openid,scope}' not like '%payments%'
            group by g.data#>>'{clientId}'
)
   select   convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}' Organisation_Name,
            CAST(sum(t1.Qtd_Auth_Nao_Iniciada+t1.Qtd_Auth_Codes) AS integer) as Qtd_Auth_Nao_Iniciada,
            CAST(sum(t1.Qtd_Auth_Codes) AS integer) as Qtd_Auth_Codes,
            CAST(sum(t1.Qtd_Redirects) AS integer) as Qtd_Redirects,
            CAST(sum(t1.Qtd_Redirects_Receptor) AS integer) as Qtd_Redirects_Receptor
    from  "Clients" c, t1
where c.id = t1.id
group by convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}';
END;$function$;