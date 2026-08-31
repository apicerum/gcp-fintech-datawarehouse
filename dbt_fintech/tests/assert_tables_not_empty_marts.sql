-- Regla de negocio: Verificar que las tablas dimensionales y de hechos de Marts no estén vacías
select 'dim_users' as table_name, count(*) as row_count 
from {{ ref('dim_users') }} 
having count(*) = 0

union all

select 'fct_transactions' as table_name, count(*) as row_count 
from {{ ref('fct_transactions') }} 
having count(*) = 0