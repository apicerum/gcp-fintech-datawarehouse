with users as (
    select * from {{ ref('stg_users') }}
),

subscriptions as (
    select * from {{ ref('stg_subscriptions') }}
),

transactions as (
    select * from {{ ref('stg_transactions') }}
),

user_tx_summary as (
    select
        user_id,
        count(transaction_id) as total_transactions,
        sum(case when transaction_status = 'COMPLETED' then transaction_amount else 0 end) as total_spent_usd,
        max(transaction_at) as last_transaction_at
    from transactions
    group by 1
),

user_sub_summary as (
    select
        user_id,
        count(subscription_id) as total_subscriptions,
        max(subscription_start_at) as latest_subscription_at
    from subscriptions
    group by 1
)

select
    u.user_id,
    u.full_name,
    u.user_email,
    u.country_code,
    u.user_created_at,
    u.is_user_active,
    coalesce(s.total_subscriptions, 0) as total_subscriptions,
    coalesce(t.total_transactions, 0) as total_transactions,
    coalesce(t.total_spent_usd, 0) as total_spent_usd,
    t.last_transaction_at
from users u
left join user_tx_summary t on u.user_id = t.user_id
left join user_sub_summary s on u.user_id = s.user_id