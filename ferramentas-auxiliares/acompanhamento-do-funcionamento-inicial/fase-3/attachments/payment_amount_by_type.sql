create or replace function payment_amount_by_type(dt_start date, dt_end date)
	returns table (
		type        			TEXT,
        amount                  DECIMAL,
		qty_payments			BIGINT
	)
language plpgsql
as $function$
begin
    return query
        select 
            case
                    when c.tp_payment = 1 then 'PIX'
                    when c.tp_payment = 2 then 'TED'
                    when c.tp_payment = 3 then 'TEF'
                    else c.tp_payment::text
                end as "type",
                sum(p.amount) as amount,
                count(distinct(p.id)) as qty_payment
            from payment p 
                inner join payment_request pr on pr.id = p.id_payment_request 
                inner join consent c on c.id = pr.id_consent
                where p.dt_payment between dt_start and dt_end
                and p.payment_status not in (3, 6)
            group by c.tp_payment;
end;$function$;