CREATE OR REPLACE FUNCTION payment_consent_extract_authorization_data(dt_start date, dt_end date, is_automatic boolean, p_dblink_conn TEXT)
RETURNS TABLE(
    itp text, 
    qty_auth_initiated int, 
    qty_auth_codes int, 
    qty_auth_redirects_itp int, 
    qty_access_token int, 
    product text, 
    authorisation_flow text
) 
LANGUAGE plpgsql
AS $function$
DECLARE 
    dt_start_utc timestamptz;
    dt_end_interval date;
    dt_end_utc timestamptz;
BEGIN
    SELECT dt_end + interval '1 day' INTO dt_end_interval;
    SELECT dt_start::date::timestamp AT TIME ZONE 'UTC' INTO dt_start_utc;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'UTC' INTO dt_end_utc;

    IF is_automatic THEN
        RETURN QUERY
        with t1 as (
        select c.id,
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
                x.decoded#>>'{scope}' like '%recurring-consent%'
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
            and 	g.data#>>'{openid,scope}' like '%recurring-consent%'
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
            and     g.data#>>'{openid,scope}' like '%recurring-consent%'
            group by g.data#>>'{clientId}'
        )
        select get_conglomerate_name(convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}') as itp,
               CAST(sum(t1.Qtd_Auth_Nao_Iniciada+t1.Qtd_Auth_Codes) AS integer)                                                                                                    as qty_auth_initiated,
               CAST(sum(t1.Qtd_Auth_Codes) AS integer)                                                                                                                             as qty_auth_codes,
               CAST(sum(t1.Qtd_Redirects) AS integer)                                                                                                                              as qty_auth_redirects,
               CAST(sum(t1.Qtd_Redirects_Receptor) AS integer)                                                                                                                     as qty_access_token,
               NULL                                                                                                                                                                as product,
               NULL                                                                                                                                                                as authorisation_flow
        from  "Clients" c, t1
        where c.id = t1.id
        group by itp
        order by itp asc, qty_auth_initiated DESC;
    ELSE
        RETURN QUERY
        WITH t1 AS (
            SELECT 
                c.id,
                COUNT(DISTINCT consentId) AS Qtd_Auth_Nao_Iniciada,
                0 AS Qtd_Auth_Codes,
                0 AS Qtd_Redirects,
                0 AS Qtd_Redirects_Receptor,
                split_part(consentId, ':', 4)::uuid as consentId
            FROM (
                WITH x AS (
                    SELECT
                        convert_from(decode_base64url(regexp_replace(data#>>'{request}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json AS decoded,
                        "createdAt"
                    FROM "PushedAuthorizationRequests" par
                    WHERE par."createdAt" BETWEEN dt_start_utc AND dt_end_utc
                )
                SELECT
                    (regexp_matches(x.decoded#>>'{scope}', '(consent\:(.*?)\:(.*?)\:(.{36}))'))[1] AS consentId,
                    c.id
                FROM x,
                    "Clients" c
                WHERE
                    (x.decoded#>>'{scope}' LIKE '%consent%' AND x.decoded#>>'{scope}' LIKE '%payments%' AND x.decoded#>>'{scope}' NOT LIKE '%recurring%')
                    AND x."createdAt" BETWEEN dt_start_utc AND dt_end_utc
                    AND c.id = x.decoded#>>'{client_id}'
            ) t1,
            "Clients" c
            WHERE t1.id = c.id
            GROUP BY c.id, consentId
            UNION ALL
            SELECT
                g.data#>>'{clientId}' AS id,
                0 AS Qtd_Auth_Nao_Iniciada,
                COUNT(ac.*) AS Qtd_Auth_Codes,
                COUNT(ac.*) AS Qtd_Redirects,
                0 AS Qtd_Redirects_Receptor,
                split_part((regexp_matches(g.data#>>'{openid,scope}', '(consent\:(.*?)\:(.*?)\:(.{36}))'))[1], ':', 4)::uuid as consentId
            FROM "AuthorizationCodes" ac,
                "Grants" g
            WHERE g."createdAt" BETWEEN dt_start_utc AND dt_end_utc
            AND ac."grantId" = g.id
            AND (g.data#>>'{openid,scope}' LIKE '%consent%' AND g.data#>>'{openid,scope}' LIKE '%payments%' AND g.data#>>'{openid,scope}' NOT LIKE '%recurring%')
            GROUP BY g.data#>>'{clientId}', consentId
            UNION ALL
            SELECT
                g.data#>>'{clientId}' AS id,
                0 AS Qtd_Auth_Nao_Iniciada,
                0 AS Qtd_Auth_Codes,
                0 AS Qtd_Redirects,
                COUNT(ac.*) AS Qtd_Redirects_Receptor,
                split_part((regexp_matches(g.data#>>'{openid,scope}', '(consent\:(.*?)\:(.*?)\:(.{36}))'))[1], ':', 4)::uuid as consentId
            FROM "AuthorizationCodes" ac,
                "Grants" g
            WHERE g."createdAt" BETWEEN dt_start_utc AND dt_end_utc
            AND ac."grantId" = g.id
            AND ac."consumedAt" IS NOT NULL
            AND (g.data#>>'{openid,scope}' LIKE '%consent%' AND g.data#>>'{openid,scope}' LIKE '%payments%' AND g.data#>>'{openid,scope}' NOT LIKE '%recurring%')
            GROUP BY g.data#>>'{clientId}', consentId
        )
        SELECT subquery.itp,
            subquery.qty_auth_initiated,
            subquery.qty_auth_codes,
            subquery.qty_auth_redirects,
            subquery.qty_access_token,
            subquery.product,
            subquery.authorisation_flow
        FROM 
        (SELECT 
            get_conglomerate_name(convert_from(decode_base64url(regexp_replace(c.data#>>'{software_statement}', '^(.*?)\.(.*?)\.(.*?)$', '\2')), 'UTF-8')::json#>>'{org_name}') AS itp,
            CAST(SUM(t1.Qtd_Auth_Nao_Iniciada + t1.Qtd_Auth_Codes) AS integer) AS qty_auth_initiated,
            CAST(SUM(t1.Qtd_Auth_Codes) AS integer) AS qty_auth_codes,
            CAST(SUM(t1.Qtd_Redirects) AS integer) AS qty_auth_redirects,
            CAST(SUM(t1.Qtd_Redirects_Receptor) AS integer) AS qty_access_token,
            COALESCE(gcpf.product, NULL) AS product,
            COALESCE(gcpf.authorisation_flow, NULL) AS authorisation_flow
        FROM "Clients" c
        INNER JOIN t1 ON c.id = t1.id
        INNER JOIN LATERAL get_consent_product_flow(t1.consentId, p_dblink_conn) gcpf ON t1.consentId IS NOT NULL
        GROUP BY itp, gcpf.product, gcpf.authorisation_flow) subquery
        WHERE subquery.product in ('IMMEDIATE','SCHEDULED')
        ORDER BY subquery.itp ASC, subquery.product ASC, subquery.authorisation_flow ASC;
    END IF;
END;
$function$;