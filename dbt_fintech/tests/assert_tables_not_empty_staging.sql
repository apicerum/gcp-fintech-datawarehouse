-- Regla de negocio: Verificar que las tablas de Staging tengan al menos 1 registro
select 'stg_users' as table_name, count(*) as row_count 
from {{ ref('stg_users') }} 
having count(*) = 0

union all

select 'stg_subscriptions' as table_name, count(*) as row_count 
from {{ ref('stg_subscriptions') }} 
having count(*) = 0

union all

select 'stg_transactions' as table_name, count(*) as row_count 
from {{ ref('stg_transactions') }} 
having count(*) = 0