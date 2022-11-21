CREATE OR REPLACE FUNCTION consent_consolidated_stock()
    RETURNS TABLE (
        Clientes_Unicos_PF_Total INT,
        Clientes_Unicos_PJ_Total INT
)
LANGUAGE SQL
AS $$
select  SUM(CASE WHEN tb.sha_business_document_number IS NULL THEN 1 ELSE 0 END) AS Clientes_Unicos_PF_Total,
		SUM(CASE WHEN tb.sha_business_document_number IS NOT NULL THEN 1 ELSE 0 END) AS Clientes_Unicos_PJ_Total
from (
	SELECT distinct c.sha_business_document_number,
	c.sha_person_document_number 
	FROM   consent c
	WHERE status = 1 
	AND   tp_consent = 1
	AND   c.dt_expiration > CURRENT_TIMESTAMP
) tb$$;