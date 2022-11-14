CREATE OR REPLACE FUNCTION consent_consolidated_stock()
    RETURNS TABLE (
        Clientes_Unicos_PF_Total INT,
        Clientes_Unicos_PJ_Total INT
)
LANGUAGE SQL
AS $$
SELECT  SUM(CASE WHEN c.sha_business_document_number IS NULL THEN 1 ELSE 0 END) AS Clientes_Unicos_PF_Total,
        SUM(CASE WHEN c.sha_business_document_number IS NOT NULL THEN 1 ELSE 0 END) AS Clientes_Unicos_PJ_Total
FROM   consent c
WHERE status = 1 
AND   tp_consent = 1$$;