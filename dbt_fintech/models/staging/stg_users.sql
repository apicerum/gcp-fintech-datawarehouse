with source as (
    select * from {{ source('fintech_raw', 'raw_users') }}
),

renamed as (
    select
        cast(user_id as string) as user_id,
        cast(full_name as string) as full_name,
        cast(email as string) as user_email,
        cast(country as string) as country_code,
        cast(signup_date as date) as signup_date,
        cast(risk_category as string) as risk_category,
        cast(is_active as boolean) as is_user_active
    from source
)

select * from renamed