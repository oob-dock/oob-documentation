CREATE OR REPLACE FUNCTION CONSENT_USAGE_REPORT(start_date DATE, end_date DATE, skip BIGINT DEFAULT 0,
                                          take BIGINT DEFAULT NULL)
    RETURNS TABLE
            (
                receptor             TEXT,
                quantity_client      BIGINT,
                quantity_non_client  BIGINT,
                receptor_org_id	     TEXT	
            )
AS
$function$
DECLARE start_date_utc timestamptz;
DECLARE end_date_interval date;
DECLARE end_date_utc timestamptz;
BEGIN
    SELECT end_date + interval '1 day' into end_date_interval;
    SELECT start_date::date::timestamp AT TIME ZONE 'America/Sao_Paulo' into start_date_utc;
    SELECT end_date_interval::date::timestamp AT TIME ZONE 'America/Sao_Paulo' into end_date_utc;

    RETURN QUERY SELECT t.org_name::TEXT                                                                       receptor,
                        count(c.id) FILTER(WHERE c.account_holder_status=1 or c.account_holder_status is null) quantity_client,
                        count(c.id) FILTER(WHERE c.account_holder_status=2)                                    quantity_non_client,
                        t.org_id::TEXT                                                                         receptor_org_id
                 FROM consent c
                          INNER JOIN tpp t ON c.id_tpp = t.id
                 WHERE c.dt_creation BETWEEN start_date_utc AND end_date_utc
                   AND (c.dt_expiration is null or c.dt_expiration >= start_date_utc)
                   AND c.tp_consent IN (1)
                 GROUP BY receptor, receptor_org_id
                 ORDER BY receptor ASC, quantity_client DESC
                 LIMIT take OFFSET skip;
END;
$function$ LANGUAGE plpgsql;