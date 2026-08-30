with source as (
    select * from {{ source('fintech_raw', 'raw_subscriptions') }}
),

renamed as (
    select
        cast(subscription_id as string) as subscription_id,
        cast(user_id as string) as user_id,
        cast(plan_type as string) as plan_type,
        cast(status as string) as subscription_status,
        cast(start_date as timestamp) as subscription_start_at
    from source
)

select * from renamed