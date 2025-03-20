CREATE OR REPLACE FUNCTION organization_as_function_access_token_generated(p_end_date date, p_dblink_conn text)
 RETURNS TABLE(access_token_consents_array text)
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- Return the aggregated payment consent summary
  RETURN QUERY
    select 'array [' || string_agg(tb1.access_token_consents, ',') || ']' as access_token_consents_array
    FROM (
    -- Fetch data from local as_function_access_token_generated function
       SELECT REPLACE(REPLACE(access_token_consents, 'array [', ''), ']', '') AS access_token_consents
        FROM as_function_access_token_generated(p_end_date)
        UNION ALL
        -- Fetch data from remote as_function_access_token_generated function via dblink
        SELECT access_token_consents 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT REPLACE(REPLACE(access_token_consents, ''array ['', ''''), '']'', '''') AS access_token_consents FROM as_function_access_token_generated(%L)',
            p_end_date
            )
            ) AS t(
                access_token_consents text
            )
        ) AS tb1;
END;
$function$
;
