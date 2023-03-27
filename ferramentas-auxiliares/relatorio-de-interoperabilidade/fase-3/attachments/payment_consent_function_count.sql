CREATE OR REPLACE FUNCTION payment_consent_count(start_date DATE, end_date DATE)
    RETURNS TABLE
            (
                itp                   TEXT,
                quantity_request           BIGINT,
                quantity_consent           BIGINT
            )
AS
$function$
DECLARE start_date_utc timestamptz;
DECLARE end_date_interval date;
DECLARE end_date_utc timestamptz;
BEGIN
    SELECT end_date + interval '1 day' into end_date_interval;
    SELECT start_date::date::timestamp AT TIME ZONE 'UTC' into start_date_utc;
    SELECT end_date_interval::date::timestamp AT TIME ZONE 'UTC' into end_date_utc;

                RETURN QUERY 
                  SELECT t.org_name::TEXT                itp,
                    count(c.id)                          quantity_request,
                    count(c.id)                          quantity_consent
                  FROM consent c
                    INNER JOIN tpp t ON c.id_tpp = t.id
                  WHERE c.dt_creation BETWEEN start_date_utc AND end_date_utc
                    AND c.tp_consent = 2
                  GROUP BY t.org_name
                  ORDER BY t.org_name ASC, quantity_request DESC;
END;
$function$ LANGUAGE plpgsql;