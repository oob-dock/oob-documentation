CREATE OR REPLACE FUNCTION as_function_access_token_generated(dt_end date)
RETURNS TABLE(access_token_consents text)
 LANGUAGE plpgsql
AS $function$
declare dt_end_interval date;
DECLARE dt_end_utc timestamptz;
begin
    SELECT dt_end + interval '1 day' into dt_end_interval;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'UTC' into dt_end_utc;
    
    RETURN QUERY
    select 'array [' || string_agg('''' || split_part(g.data#>>'{openid,scope}', ':', 4) || '''', ',') || ']' as access_token_consents
        from "AuthorizationCodes" ac 
        inner join "Grants" g on g.id = ac."grantId" 
    where ac."consumedAt" is not null
        and g."createdAt" <= dt_end_utc
        and g.data#>>'{openid,scope}' like '%consent%'
        and g.data#>>'{openid,scope}' not like '%payments%';

END;$function$;