with source as (
    select * from {{ source('fintech_raw', 'raw_subscriptions') }}
),

renamed as (
    select
        cast(subscription_id as string) as subscription_id,
        cast(user_id as string) as user_id,
        cast(plan_id as string) as plan_id,
        cast(status as string) as subscription_status,
        cast(billing_cycle as string) as billing_cycle,
        cast(start_date as date) as subscription_start_date,
        cast(amount as numeric) as subscription_amount
    from source
)

select * from renamed