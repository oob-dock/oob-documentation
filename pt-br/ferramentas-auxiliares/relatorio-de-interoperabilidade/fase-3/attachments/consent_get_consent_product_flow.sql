CREATE OR REPLACE FUNCTION get_consent_product_flow(uuid UUID)
RETURNS TABLE (
	id_consent UUID,
	product TEXT,
	authorisation_flow TEXT
) AS $$
BEGIN
	RETURN QUERY
	SELECT 
		c.id AS id_consent,
		CASE 
			WHEN c.tp_modality_payment = 1 THEN 'IMMEDIATE'
			WHEN c.tp_modality_payment = 2 THEN 'SCHEDULED'
			WHEN c.tp_modality_payment = 3 THEN 'VRP'
			WHEN c.tp_modality_payment = 4 THEN 'SWEEPING'
			WHEN c.tp_modality_payment = 5 THEN 'AUTOMATIC'
			ELSE 'RECURRENT'
		END AS product,
		CASE
			WHEN c.id_enrollment IS NOT NULL THEN 'FIDO_FLOW'
			ELSE 'HYBRID_FLOW'
		END AS authorisation_flow
	FROM consent c
	WHERE c.id = uuid;
END;
$$ LANGUAGE plpgsql;