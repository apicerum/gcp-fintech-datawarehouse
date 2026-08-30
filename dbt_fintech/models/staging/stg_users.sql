with source as (
    select * from {{ source('fintech_raw', 'raw_users') }}
),

renamed as (
    select
        cast(user_id as string) as user_id,
        cast(first_name as string) as first_name,
        cast(last_name as string) as last_name,
        concat(first_name, ' ', last_name) as full_name,
        cast(email as string) as user_email,
        cast(country as string) as country_code,
        cast(created_at as timestamp) as user_created_at,
        cast(is_active as boolean) as is_user_active
    from source
)

select * from renamed