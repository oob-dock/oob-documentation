create or replace function percentile_p95(dt_start date, dt_end date)
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
    dt_start_utc timestamptz;
    dt_end_interval date;
    dt_end_utc timestamptz;
    dt_start_pattern text;
begin
    select dt_end + INTERVAL '1 day' INTO dt_end_interval;
    select dt_start::date::timestamp AT TIME ZONE 'UTC' INTO dt_start_utc;
    select dt_end_interval::date::timestamp AT TIME ZONE 'UTC' INTO dt_end_utc;

    return query
        with endpoint_list as (
            select
                case
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/consents/v%/consents/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/consents/.*', 'v\1/consents/{consentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/accounts/%/bills/%/transactions' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/accounts/.*/bills/.*/transactions', '/accounts/{creditCardAccountId}/bills/{billId}/transactions'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%credit-cards-accounts/v%/accounts/%/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/accounts/.*/', '/accounts/{creditCardAccountId}/'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%credit-cards-accounts/v%/accounts/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/accounts/.*', '/accounts/{creditCardAccountId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%bank-fixed-incomes/v%/investments/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/investments/.*', '/investments/{investmentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%credit-fixed-incomes/v%/investments/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/investments/.*', '/investments/{investmentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%funds/v%/investments/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/investments/.*', '/investments/{investmentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%treasure-titles/v%/investments/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/investments/.*', '/investments/{investmentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%variable-incomes/v%/investments/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/investments/.*', '/investments/{investmentId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/v%/accounts/%/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/accounts/.*/(.*)', 'v\1/accounts/{accountId}/\2'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/v%/accounts/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', 'v(.*)/accounts/.*', 'v\1/accounts/{accountId}'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/contracts/%/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/contracts/.*/', '/contracts/{contractId}/'))
                    WHEN r.event_data#>>'{endpoint}' LIKE '%/contracts/%' then (REGEXP_REPLACE(r.event_data#>>'{endpoint}', '/contracts/.*', '/contracts/{contractId}'))
                    else (r.event_data#>>'{endpoint}')
                end                                                             as endpoint_uri,
                (r.created_at AT TIME ZONE 'UTC' AT TIME ZONE 'UTC-3')::date    as metric_date,
                r.event_data#>>'{httpMethod}'                                   as http_method,
                r.brand_id                                                      as brand_id,
                r.event_data#>>'{processTimespan}'                              as processTimespan
            from report r
                where r.created_at between dt_start_utc and dt_end_utc and r.event_role = 'SERVER'
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
            el.endpoint_uri,
            el.http_method,
            el.metric_date,
            el.brand_id;
end;$function$;