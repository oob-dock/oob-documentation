CREATE OR REPLACE FUNCTION CONSENT_USAGE_REPORT(start_date DATE, end_date DATE, skip BIGINT DEFAULT 0,
                                          take BIGINT DEFAULT NULL)
    RETURNS TABLE
            (
                receptor           TEXT,
                quantity           BIGINT,
                consent_id_example TEXT,
                cpf_hash           TEXT,
                cnpj_hash          TEXT
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

    RETURN QUERY SELECT t.org_name::TEXT                     receptor,
                        count(c.id)                          quantity,
                        max(c.id_consent_external)           consent_id_example,
                        c.sha_person_document_number::TEXT   cpf_hash,
                        c.sha_business_document_number::TEXT cnpj_hash
                 FROM consent c
                          INNER JOIN tpp t ON c.id_tpp = t.id
                 WHERE c.dt_creation BETWEEN start_date AND end_date
                   AND c.dt_expiration >= start_date
                   AND c.tp_consent IN (1)
                 GROUP BY receptor, cpf_hash, cnpj_hash
                 ORDER BY receptor ASC, quantity DESC
                 LIMIT take OFFSET skip;
END;
$function$ LANGUAGE plpgsql;
