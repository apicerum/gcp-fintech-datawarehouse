-- Regla de negocio: Un usuario inactivo no puede tener subcripciones activas
with users as (
    select user_id from {{ ref('stg_users') }} where is_user_active = false
),

subscriptions as (
    select subscription_id, user_id 
    from {{ ref('stg_subscriptions') }} 
    where subcription_status = 'ACTIVE'
)

select
    t.subscription_id,
    t.user_id
from subscriptions t
inner join users u on t.user_id = u.user_id