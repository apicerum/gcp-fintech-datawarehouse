with source as (
    select * from {{ source('fintech_raw', 'raw_transactions') }}
),

renamed as (
    select
        cast(transaction_id as string) as transaction_id,
        cast(subscription_id as string) as subscription_id,
        cast(user_id as string) as user_id,
        cast(transaction_timestamp as timestamp) as transaction_at,
        cast(amount as numeric) as gross_amount,
        cast(fee as numeric) as transaction_fee,
        cast(gross_amount - fee as numeric) as net_amount,
        cast(payment_method as string) as payment_method,
        cast(status as string) as payment_status
    from source
)

select * from renamed