-- Regla de negocio: El monto de una transacción no puede ser negativo
select
    transaction_id,
    transaction_amount
from {{ ref('stg_transactions') }}
where transaction_amount < 0