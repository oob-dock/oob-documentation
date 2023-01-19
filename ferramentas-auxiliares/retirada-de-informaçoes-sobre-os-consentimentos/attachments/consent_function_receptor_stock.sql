CREATE OR REPLACE FUNCTION consent_receptor_stock()
    RETURNS TABLE (
        org_name VARCHAR,
        qtd_Estoque_Consentimentos_Ativos BIGINT
) 
LANGUAGE SQL
AS $$
SELECT  t.org_name,
        COUNT(c.*) qtd_Estoque_Consentimentos_Ativos
FROM  consent c, 
      tpp t
WHERE c.id_tpp  = t.id
AND   c.status = 1
AND   c.tp_consent = 1
AND   c.dt_expiration > CURRENT_TIMESTAMP
GROUP BY t.org_name$$;