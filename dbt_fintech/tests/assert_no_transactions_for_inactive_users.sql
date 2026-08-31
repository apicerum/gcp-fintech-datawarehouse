-- Regla de negocio: Un usuario inactivo no puede completar transacciones
with users as (
    select user_id from {{ ref('stg_users') }} where is_user_active = false
),

transactions as (
    select transaction_id, user_id 
    from {{ ref('stg_transactions') }} 
    where transaction_status = 'COMPLETED'
)

select
    t.transaction_id,
    t.user_id
from transactions t
inner join users u on t.user_id = u.user_id