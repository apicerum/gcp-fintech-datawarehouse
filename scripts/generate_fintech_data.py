import os
import datetime
import random
import uuid
from google.cloud import bigquery
import pandas as pd
from faker import Faker

fake = Faker()

# Extrae el proyecto de la variable de entorno o usa el valor por defecto
PROJECT_ID = os.getenv("GCP_PROJECT_ID", "gcp-fintech-datawarehouse")
DATASET_ID = "fintech_raw_dev"
LOCATION = "us-central1"

NUM_USERS = 5000
NUM_TRANSACTIONS = 50000
NUM_SUBSCRIPTIONS = 3000

print(f"--> Conectando a BigQuery ({PROJECT_ID}.{DATASET_ID} en {LOCATION})...")
client = bigquery.Client(project=PROJECT_ID, location=LOCATION)

# ------------------------------------------------------------------
# 1. Generar Usuarios (raw_users)
# ------------------------------------------------------------------
print(f"Generando {NUM_USERS} usuarios...")
users_data = []
user_ids = []

for _ in range(NUM_USERS):
    u_id = str(uuid.uuid4())
    user_ids.append(u_id)
    created_at = fake.date_time_between(start_date="-2y", end_date="now")
    
    users_data.append({
        "user_id": u_id,
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "email": fake.email(),
        "country": fake.country_code(),
        "created_at": created_at.strftime("%Y-%m-%d %H:%M:%S"),
        "is_active": fake.boolean(chance_of_getting_true=85)
    })

df_users = pd.DataFrame(users_data)

# ------------------------------------------------------------------
# 2. Generar Transacciones (raw_transactions)
# ------------------------------------------------------------------
print(f"Generando {NUM_TRANSACTIONS} transacciones...")
transactions_data = []
tx_types = ["TRANSFER", "PAYMENT", "WITHDRAWAL", "DEPOSIT"]
statuses = ["COMPLETED", "PENDING", "FAILED"]

for _ in range(NUM_TRANSACTIONS):
    tx_time = fake.date_time_between(start_date="-1y", end_date="now")
    transactions_data.append({
        "transaction_id": str(uuid.uuid4()),
        "user_id": random.choice(user_ids),
        "amount": round(random.uniform(1.50, 2500.00), 2),
        "currency": "USD",
        "transaction_type": random.choice(tx_types),
        "status": random.choice(statuses),
        "created_at": tx_time.strftime("%Y-%m-%d %H:%M:%S")
    })

df_transactions = pd.DataFrame(transactions_data)

# ------------------------------------------------------------------
# 3. Generar Suscripciones (raw_subscriptions)
# ------------------------------------------------------------------
print(f"Generando {NUM_SUBSCRIPTIONS} suscripciones...")
subscriptions_data = []
plans = ["BASIC", "PREMIUM", "ENTERPRISE"]

for _ in range(NUM_SUBSCRIPTIONS):
    sub_start = fake.date_time_between(start_date="-1y", end_date="now")
    subscriptions_data.append({
        "subscription_id": str(uuid.uuid4()),
        "user_id": random.choice(user_ids),
        "plan_type": random.choice(plans),
        "status": random.choice(["ACTIVE", "CANCELLED", "PAST_DUE"]),
        "start_date": sub_start.strftime("%Y-%m-%d %H:%M:%S")
    })

df_subscriptions = pd.DataFrame(subscriptions_data)

# ------------------------------------------------------------------
# 4. Carga a BigQuery (WRITE_TRUNCATE para idempotent runs)
# ------------------------------------------------------------------
tables = {
    "raw_users": df_users,
    "raw_transactions": df_transactions,
    "raw_subscriptions": df_subscriptions
}

job_config = bigquery.LoadJobConfig(
    write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE
)

for table_name, df in tables.items():
    table_id = f"{PROJECT_ID}.{DATASET_ID}.{table_name}"
    print(f"Cargando {len(df)} filas en {table_id}...")
    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()  # Espera a que termine la carga

print("--> ¡Ingesta completada exitosamente!")