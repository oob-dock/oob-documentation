CREATE OR REPLACE FUNCTION get_conglomerate_name(org_name TEXT)
RETURNS TEXT AS $$
BEGIN
    IF org_name ILIKE '%Banrisul%' OR 
       org_name ILIKE '%RIO GRANDE DO SUL%' OR 
       org_name ILIKE '%ESTADO DO RS%' THEN
        RETURN 'Banrisul';
    ELSIF org_name ILIKE '%BANCO DO BRASIL%' OR 
          org_name ILIKE '%Investimentos BB%' THEN
        RETURN 'BB';
    ELSIF org_name ILIKE '%BMG%' THEN
        RETURN 'BMG';
    ELSIF org_name ILIKE '%BRADESCO%' OR 
          org_name ILIKE '%LOSANGO%' OR 
          org_name ILIKE '%BRADESCARD%' OR 
          org_name ILIKE '%ÁGORA%' THEN
        RETURN 'Bradesco';
    ELSIF org_name ILIKE '%Bocom%' THEN
        RETURN 'Bocom';
    ELSIF org_name ILIKE '%BTG%' THEN
        RETURN 'BTG';
    ELSIF org_name ILIKE '%BV%' OR 
          org_name ILIKE '%Votorantim%' OR 
          org_name ILIKE '%BCO VOTORANTIM%' THEN
        RETURN 'BV';
    ELSIF org_name ILIKE '%CAIXA%' THEN
        RETURN 'Caixa';
    ELSIF org_name ILIKE '%ITAU%' OR 
          org_name ILIKE '%ITAUCARD%' OR 
          org_name ILIKE '%ITAUBANK%' OR 
          org_name ILIKE '%LUIZACRED%' OR 
          org_name ILIKE '%HIPERCARD%' OR 
          org_name ILIKE '%UNIBANCO%' OR 
          org_name ILIKE '%REDECARD%' OR 
          org_name ILIKE '%INTRAG DTVM%' OR 
          org_name ILIKE '%MICROINVEST%' OR 
          org_name ILIKE '%BBA%' OR 
          org_name ILIKE '%ITAÚ%' THEN
        RETURN 'Itau';
    ELSIF org_name ILIKE '%MERCADO PAGO%' THEN
        RETURN 'Mecado Pago';
    ELSIF org_name ILIKE '%ORIGINAL%' THEN
        RETURN 'Original';
    ELSIF org_name ILIKE '%PAN%' THEN
        RETURN 'Pan';
    ELSIF org_name ILIKE '%SAFRA%' THEN
        RETURN 'Safra';
    ELSIF org_name ILIKE '%SANTANDER%' OR 
          org_name ILIKE '%BCO SANTANDER (BRASIL) S.A.%' OR 
          org_name ILIKE '%RCI%' OR 
          org_name ILIKE '%AYMORE%' OR 
          org_name ILIKE '%TORO CTVM%' OR 
          org_name ILIKE '%HYUNDAI%' OR 
          org_name ILIKE '%BCO PSA FINANCE%' OR 
          org_name ILIKE '%S3 CACEIS%' OR 
          org_name ILIKE '%SUPER PAGAMENTOS E ADMINISTRACAO%' OR 
          org_name ILIKE '%GETNET ADQUIRENCIA E SERVICOS%' THEN
        RETURN 'Santander';
    ELSIF org_name ILIKE '%Sicoob%' THEN
        RETURN 'Sicoob';
    ELSIF org_name ILIKE '%SICREDI%' THEN
        RETURN 'Sicred';
    ELSIF org_name ILIKE '%NU PAGAMENTOS%' OR 
          org_name ILIKE '%NUBANK%' THEN
        RETURN 'Nubank';
    ELSIF org_name ILIKE '%GERU%' THEN
        RETURN 'Geru';
    ELSIF org_name ILIKE '%PICPAY%' THEN
        RETURN 'Picpay';
    ELSIF org_name ILIKE '%BNB%' THEN
        RETURN 'BNB';
    ELSIF org_name ILIKE '%BNDES%' THEN
        RETURN 'BNDS';
    ELSIF org_name ILIKE '%XP%' THEN
        RETURN 'XP';
    ELSIF org_name ILIKE '%Citibank%' THEN
        RETURN 'Citibank';
    ELSIF org_name ILIKE '%Quanto TSP%' THEN
        RETURN 'Quanto';
    ELSIF org_name ILIKE '%UP.P SEP S.A.%' THEN
        RETURN 'UPP SEP';
    ELSIF org_name ILIKE '%BCO PAULISTA%' THEN
        RETURN 'Paulista';
    ELSIF org_name ILIKE '%QI SCD%' THEN
        RETURN 'QI SCD';
    ELSIF org_name ILIKE '%DIGIO%' THEN
        RETURN 'Digio';
    ELSIF org_name ILIKE '%BCO DO NORDESTE DO BRASIL%' THEN
        RETURN 'BNB';
    ELSIF org_name ILIKE '%BCO BOCOM BBM%' THEN
        RETURN 'Bocom';
    ELSIF org_name ILIKE '%Open Banking Brasil - Raidiam%' THEN
        RETURN 'Raidiam';
    ELSIF org_name ILIKE '%Quanto Network%' THEN
        RETURN 'Quanto TSP';
    ELSIF org_name ILIKE '%BCO CITIBANK S.A%' THEN
        RETURN 'Citibank';
    ELSIF org_name ILIKE '%CRYSTAL BMC%' THEN
        RETURN 'Crystal BMC';
    ELSIF org_name ILIKE '%Belvo%' THEN
        RETURN 'Belvo';
    ELSIF org_name ILIKE '%RECARGAPAY%' THEN
        RETURN 'Recargapay';
    ELSIF org_name ILIKE '%INIPAY%' THEN
        RETURN 'Inipay';
    ELSIF org_name ILIKE '%STONE%' THEN
        RETURN 'Stone';
    ELSIF org_name ILIKE '%CELCOIN%' THEN
        RETURN 'Celcoin';
    ELSIF org_name ILIKE '%CLOUDWALK%' THEN
        RETURN 'Cloudwalk';
    ELSIF org_name ILIKE '%FINNET%' THEN
        RETURN 'Finnet';
    ELSIF org_name ILIKE '%UNICRED%' THEN
        RETURN 'Unicred';
    ELSIF org_name ILIKE '%PLUGGY%' THEN
        RETURN 'Pluggy';
    ELSIF org_name ILIKE '%BANCO INTER%' THEN
        RETURN 'Banco Inter';
    ELSIF org_name ILIKE '%BRB%' THEN
        RETURN 'Banco de Brasília';
    ELSIF org_name ILIKE '%CUMBUCA%' THEN
        RETURN 'Cumbuca Instituição de Pagamento LTDA';
    ELSIF org_name ILIKE '%DOCK%' THEN
        RETURN 'BPP';
    ELSIF org_name ILIKE '%EFI%' OR 
          org_name ILIKE '%EFÍ%' THEN
        RETURN 'Gerencianet';
    ELSIF org_name ILIKE '%GOOGLE%' OR 
          org_name ILIKE '%GPAY%' THEN
        RETURN 'Google';
    ELSIF org_name ILIKE '%NEON%' THEN
        RETURN 'Neon';
    ELSIF org_name ILIKE '%CHICAGO%' OR
          org_name ILIKE '%FVP - INICIADOR%' THEN
        RETURN 'Ferramenta de validação e monitoramento do Open Finance Brasil';
    ELSIF org_name ILIKE '%INICIADOR%' THEN
        RETURN 'Iniciador';
    ELSIF org_name ILIKE '%PAGBANK%' OR
          org_name ILIKE '%PAGSEGURO%' THEN
        RETURN 'PagBank';
    ELSIF org_name ILIKE '%PARATI%' THEN
        RETURN 'Parati';
    ELSIF org_name ILIKE '%U4C%' THEN
        RETURN 'U4C';
    ELSE
        RETURN 'Outros';
    END IF;
END;
$$ LANGUAGE plpgsql;