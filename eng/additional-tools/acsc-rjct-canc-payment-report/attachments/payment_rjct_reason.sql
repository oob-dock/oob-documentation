CREATE OR REPLACE FUNCTION payment_rjct_reason(dt_start date, dt_end date)
    RETURNS TABLE (
        org_id 				VARCHAR,
        "date" 				DATE,
        product 			TEXT,
        authorizationFlow 	TEXT,
        nfcPix				TEXT,
        reason				TEXT,
        qty					BIGINT,
        value				NUMERIC
)
LANGUAGE plpgsql
AS $function$
DECLARE dt_start_utc timestamptz;
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
BEGIN

    SELECT dt_end + INTERVAL '1 day' INTO dt_end_interval;
    SELECT dt_start::date::timestamp AT TIME ZONE 'America/Sao_Paulo' INTO dt_start_utc;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'America/Sao_Paulo' INTO dt_end_utc;

    RETURN QUERY
        SELECT
			t.org_id 																		as org_id,
		    (p.dt_payment_status_update AT TIME ZONE 'America/Sao_Paulo')::date				as "date",
			case
				when c.tp_modality_payment = 1 then 'IMMEDIATE'
				when c.tp_modality_payment = 2 AND c.tp_schedule = 1 then 'SCHEDULED'
				when c.tp_modality_payment = 2 AND c.tp_schedule <> 1 then 'RECURRENT'
				when c.tp_modality_payment = 3 then 'VRP'
				when c.tp_modality_payment = 4 then 'SWEEPING'
				when c.tp_modality_payment = 5 then 'AUTOMATIC'
				else ''
			end																				as product,
			coalesce(pr.payment_payload_data->'data'->0->>'authorisationFlow', 'HYBRID_FLOW') 	as authorisationFlow,
			coalesce(c.payment_data->>'nfcHeader', 'false')									as nfcPix,
			p.rejection_reason->>'code'  													as reason,
			COUNT(DISTINCT p.id)															as qty,
			SUM(p.amount)																	as amount
		FROM payment p
				INNER JOIN payment_request pr 	ON p.id_payment_request = pr.id
				INNER JOIN consent c		  	ON c.id = pr.id_consent
				INNER JOIN tpp t				ON t.id = c.id_tpp
		WHERE p.dt_payment_status_update BETWEEN dt_start_utc AND dt_end_utc AND p.payment_status = 6
		GROUP BY (1,2,3,4,5,6);
END;$function$;