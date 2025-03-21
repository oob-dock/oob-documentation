CREATE OR REPLACE FUNCTION payment_consent_extract_authorization_data(dt_start date, dt_end date, is_automatic boolean)
RETURNS TABLE(itp text, qty_auth_initiated int, qty_auth_codes int, qty_auth_redirects_itp int, qty_access_token int) LANGUAGE plpgsql
AS $function$
DECLARE dt_start_utc timestamptz;
DECLARE dt_end_interval date;
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
            ((is_automatic is false and x.decoded#>>'{scope}' like '%consent%' and x.decoded#>>'{scope}' like '%payments%' and x.decoded#>>'{scope}' not like '%recurring%')
            or (is_automatic is true and x.decoded#>>'{scope}' like '%recurring-consent%'))
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
            and 	((is_automatic is false and g.data#>>'{openid,scope}' like '%consent%' and g.data#>>'{openid,scope}' like '%payments%' and g.data#>>'{openid,scope}' not like '%recurring%')
                or  (is_automatic is true and g.data#>>'{openid,scope}' like '%recurring-consent%'))
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
            and     ((is_automatic is false and g.data#>>'{openid,scope}' like '%consent%' and g.data#>>'{openid,scope}' like '%payments%' and g.data#>>'{openid,scope}' not like '%recurring%')
                or  (is_automatic is true and g.data#>>'{openid,scope}' like '%recurring-consent%'))
            group by g.data#>>'{clientId}'
)
   select   get_conglomerate_name(convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}') as itp,
            CAST(sum(t1.Qtd_Auth_Nao_Iniciada+t1.Qtd_Auth_Codes) AS integer)                                                                                                    as qty_auth_initiated,
            CAST(sum(t1.Qtd_Auth_Codes) AS integer)                                                                                                                             as qty_auth_codes,
            CAST(sum(t1.Qtd_Redirects) AS integer)                                                                                                                              as qty_auth_redirects,
            CAST(sum(t1.Qtd_Redirects_Receptor) AS integer)                                                                                                                     as qty_access_token
    from  "Clients" c, t1
where c.id = t1.id
group by itp;
END;$function$;