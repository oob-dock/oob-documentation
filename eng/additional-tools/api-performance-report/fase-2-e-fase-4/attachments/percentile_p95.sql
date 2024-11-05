create or replace function percentile_p95(dt_start date, dt_end date, organization_id uuid default null, brand_id_val varchar default null)
returns table (
    brand_id                varchar,
    metric_date             date,
    endpoint_uri            TEXT,
    http_method             TEXT,
    p95_process_time        INT
)
language plpgsql
as $function$
declare
    dt_start_utc varchar;
    dt_end_interval date;
    dt_end_utc varchar;
    dt_start_pattern text;
begin
    select dt_end + INTERVAL '1 day' INTO dt_end_interval;
    select to_char(dt_start::timestamp + interval '3 hour', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') INTO dt_start_utc;
    select to_char(dt_end_interval::timestamp + interval '3 hour', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') INTO dt_end_utc;

    return query
        with endpoint_list as (
            select
                case
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/consents/v%/consents/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/consents/[^/]+', 'v\1/consents/{consentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/accounts/%/bills/%/transactions' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/accounts/.*/bills/.*/transactions', '/accounts/{creditCardAccountId}/bills/{billId}/transactions'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%credit-cards-accounts/v%/accounts/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/accounts/[^/]+', 'v\1/accounts/{creditCardAccountId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/investments/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/investments/[^/]+', '/investments/{investmentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%accounts/v%/accounts/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/accounts/[^/]+', 'v\1/accounts/{accountId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/contracts/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/contracts/[^/]+', 'v\1/contracts/{contractId}'))
                    else (r.event_data#>>'{endpoint}')
            end 			                                      			as endpoint_uri,
                -- using timestamp to avoid error due to database timezone configuration
                (r.event_timestamp::timestamp - interval '3 hour')::date    as metric_date,
                r.event_data#>>'{httpMethod}' 					  			as http_method,
                r.brand_id										  			as brand_id,
                r.event_data#>>'{processTimespan}'				  			as processTimespan
            from report r
                where r.event_role = 'SERVER'
                and (r.server_org_id = organization_id or organization_id is null)
                and (r.brand_id  = brand_id_val or brand_id_val is null)
                and r.event_timestamp between dt_start_utc and dt_end_utc
                and r.event_data#>>'{endpoint}' not like '/open-banking/payments%'
                and r.event_data#>>'{endpoint}' not like '/open-banking/automatic-payments%'
                and r.event_data#>>'{endpoint}' not like '/open-banking/opendata%'
                and r.event_data#>>'{endpoint}' not like '/open-banking/products-services%'
                and r.event_data#>>'{endpoint}' not like '/open-banking/channels%'
        )
        select
            el.brand_id,
            el.metric_date,
            el.endpoint_uri,
            el.http_method,
            percentile_disc(0.95) within group (order by (el.processTimespan)::int) as p95_process_time_ms
        from endpoint_list el
        group by
            el.brand_id,
            el.endpoint_uri,
            el.http_method,
            el.metric_date
        order by
            el.brand_id,
            el.endpoint_uri,
            el.http_method,
            el.metric_date;
end;$function$;