CREATE OR REPLACE FUNCTION payment_consent_error_reason(dt_start date, dt_end date)
    RETURNS TABLE (
        itp VARCHAR,
        itp_org_id VARCHAR,
        error_type TEXT,
        qty_error_type BIGINT
)
LANGUAGE plpgsql
AS $function$
DECLARE dt_start_utc timestamptz;
DECLARE dt_end_interval date;
DECLARE dt_end_utc timestamptz;
BEGIN
    SELECT dt_end + INTERVAL '1 day' INTO dt_end_interval;
    SELECT dt_start::date::timestamp AT TIME ZONE 'UTC' INTO dt_start_utc;
    SELECT dt_end_interval::date::timestamp AT TIME ZONE 'UTC' INTO dt_end_utc;

    RETURN QUERY
        SELECT t.org_name   		 as itp,
               t.org_id 			 as itp_org_id,
               CASE tp_unprocessable_entity_error_code
				    WHEN 1 THEN 'SALDO_INSUFICIENTE'
				    WHEN 2 THEN 'BENEFICIARIO_INCOMPATIVEL'
				    WHEN 3 THEN 'VALOR_INCOMPATIVEL'
				    WHEN 4 THEN 'VALOR_ACIMA_LIMITE'
				    WHEN 5 THEN 'VALOR_INVALIDO'
				    WHEN 6 THEN 'COBRANCA_INVALIDA'
				    WHEN 7 THEN 'CONSENTIMENTO_INVALIDO'
				    WHEN 8 THEN 'JANELA_OPER_INVALIDA'
				    WHEN 9 THEN 'PARAMETRO_NAO_INFORMADO'
				    WHEN 10 THEN 'PARAMETRO_INVALIDO'
				    WHEN 11 THEN 'NAO_INFORMADO'
				    WHEN 12 THEN 'PAGAMENTO_DIVERGENTE_CONSENTIMENTO'
				    WHEN 13 THEN 'DETALHE_PAGAMENTO_INVALIDO'
				    WHEN 14 THEN 'PAGAMENTO_RECUSADO_DETENTORA'
				    WHEN 15 THEN 'PAGAMENTO_RECUSADO_SPI'
				    WHEN 16 THEN 'ERRO_IDEMPOTENCIA'
				    ELSE 'ERRO_DESCONHECIDO'
			   END 					  as error_type,
               COUNT(distinct c.id)   as qty_error_type
        FROM consent c
        INNER JOIN tpp t ON c.id_tpp = t.id 
        WHERE c.dt_creation BETWEEN dt_start_utc AND dt_end_utc
            AND c.tp_consent = 2
            AND c.tp_unprocessable_entity_error_code is not null
            AND exists (select 1 from history_status hs where hs.id_consent = c.id and hs.status_consent = 6 and hs.updated_on between dt_start_utc and dt_end_utc)
        GROUP BY t.org_name, t.org_id, tp_unprocessable_entity_error_code;
END;$function$;