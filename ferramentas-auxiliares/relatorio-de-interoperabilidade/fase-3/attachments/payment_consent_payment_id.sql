CREATE OR REPLACE FUNCTION payment_consent_payment_id(start_date DATE, end_date DATE, is_automatic boolean)
    RETURNS TABLE
            (
                itp                             TEXT,
                quantity_request                BIGINT,
                quantity_payment_id             BIGINT,
                quantity_completed_payment_id	BIGINT,
                quantity_schedule_payment_id    BIGINT
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
                  SELECT  t.org_name::TEXT                                           		 itp,
	                      count(distinct pr.id)                                      	     quantity_request,
                          count(distinct p.id)										         quantity_payment_id,
                          count(distinct p.id) FILTER (where p.payment_status = 7)           quantity_completed_payment_id,
                          count(distinct p.id) FILTER (where p.payment_status = 9)           quantity_schedule_payment_id
                  FROM payment_request pr
                  INNER JOIN consent c ON c.id = pr.id_consent
                  INNER JOIN tpp t ON c.id_tpp = t.id
                  LEFT JOIN payment p ON pr.id = p.id_payment_request
                  WHERE pr.dt_payment_request BETWEEN start_date_utc AND end_date_utc
                      AND c.tp_consent = 2
                      AND ((is_automatic is false AND c.tp_modality_payment IN (1,2)) OR (is_automatic is true AND c.tp_modality_payment IN (3,4,5)))
                  GROUP BY t.org_name
                  ORDER BY t.org_name ASC, quantity_request DESC;
END;
$function$ LANGUAGE plpgsql;