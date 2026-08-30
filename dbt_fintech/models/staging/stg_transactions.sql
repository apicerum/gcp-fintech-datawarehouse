with source as (
    select * from {{ source('fintech_raw', 'raw_transactions') }}
),

renamed as (
    select
        cast(transaction_id as string) as transaction_id,
        cast(user_id as string) as user_id,
        cast(amount as numeric) as transaction_amount,
        cast(currency as string) as currency,
        cast(transaction_type as string) as transaction_type,
        cast(status as string) as transaction_status,
        cast(created_at as timestamp) as transaction_at
    from source
)

select * from renamed