CREATE OR REPLACE FUNCTION get_consent_product_flow(uuid uuid, p_dblink_conn text)
 RETURNS TABLE(id_consent uuid, product text, authorisation_flow text)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY
	    SELECT * 
        FROM dblink(
            p_dblink_conn,
            FORMAT(
            'SELECT * FROM get_consent_product_flow(%L)',
            uuid
            )
            ) AS t(
            id_consent UUID,
			product TEXT,
			authorisation_flow TEXT
            );
END;
$function$;