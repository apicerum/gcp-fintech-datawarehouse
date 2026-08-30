with transactions as (
    select * from {{ ref('stg_transactions') }}
),

users as (
    select user_id, country_code, is_user_active from {{ ref('stg_users') }}
)

select
    t.transaction_id,
    t.user_id,
    u.country_code,
    t.transaction_amount,
    t.currency,
    t.transaction_type,
    t.transaction_status,
    t.transaction_at,
    extract(date from t.transaction_at) as transaction_date
from transactions t
left join users u on t.user_id = u.user_id