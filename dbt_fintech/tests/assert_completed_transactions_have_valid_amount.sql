-- Regla de negocio: Las transacciones completadas deben tener un importe mayor a cero
select
    transaction_id,
    user_id,
    transaction_status,
    transaction_amount
from {{ ref('stg_transactions') }}
where transaction_status = 'COMPLETED'
  and transaction_amount <= 0