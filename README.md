# 🚀 GCP Fintech Data Warehouse (End-to-End ELT Pipeline)

Un Data Warehouse moderno para el sector Fintech implementado en **Google Cloud Platform (GCP)**. El proyecto automatiza la infraestructura como código (IaC), la ingesta de datos sintéticos, la transformación ELT en capas mediante **dbt** y la ejecución continua a través de **GitHub Actions**.

---

## 🏗 Architecture & Data Lineage

[ Terraform (GCS Backend) ] ──> GCP Infrastructure Provisioning (Datasets & Storage)
│
[ Python + Faker ]          ──> Ingesta Raw (WRITE_TRUNCATE) ──> BigQuery: fintech_raw_dev
│
[ dbt Core + CI/CD ]        ──> Data Modeling & Transformation        │
├── Staging (Views)  ──────────────┘ ──> BigQuery: fintech_staging_dev
└── Marts (Tables)   ──────────────────> BigQuery: fintech_marts_dev

---

## 🛠 Tech Stack

* **Cloud Provider:** Google Cloud Platform (BigQuery, Cloud Storage, IAM).
* **Infrastructure as Code (IaC):** Terraform (con estado remoto en GCS).
* **Data Processing & Seeding:** Python 3.11, Pandas, PyArrow, Faker, BigQuery Client.
* **Data Transformation:** dbt Core (`dbt-bigquery`).
* **CI/CD Orchestration:** GitHub Actions.

---

## 📂 Project Structure

```text
.
├── .github/workflows/
│   └── deploy-dev.yml         # GitHub Actions CI/CD Pipeline
├── dbt_fintech/               # Proyecto de dbt Core
│   ├── macros/                # Macros personalizadas (generate_schema_name)
│   ├── models/
│   │   ├── staging/           # Vistas limpias y tipadas (stg_users, stg_transactions, etc.)
│   │   └── marts/             # Modelo Dimensional Kimball (dim_users, fct_transactions)
│   └── dbt_project.yml
├── scripts/
│   └── generate_fintech_data.py # Generación e ingesta de datos sintéticos
├── terraform/
│   ├── environments/dev/      # Declaración del entorno dev (Backend GCS, Providers)
│   └── modules/               # Módulos reutilizables de Terraform (BigQuery Datasets)
├── .gitignore
├── README.md
└── requirements.txt

📊 Data Models (Kimball Star Schema)
Layer 1: Raw (fintech_raw_dev)
Tablas crudas cargadas mediante Python:

raw_users

raw_subscriptions

raw_transactions

Layer 2: Staging (fintech_staging_dev)
Vistas de limpieza de nombres, casteo de tipos numéricos/timestamps e identificación de estados.

Layer 3: Marts (fintech_marts_dev)
Tablas de hechos y dimensiones optimizadas para consumo analítico (BI / Looker Studio):

dim_users: Vista 360 del usuario combinando métricas acumuladas de consumo, número de transacciones e historial de suscripciones.

fct_transactions: Eventos transaccionales enriquecidos con contexto geográfico y fechas desglosadas.

⚙️ CI/CD Deployment Flow (GitHub Actions)

El workflow se activa de forma automática tras cada push a la rama main:

Autenticación en GCP: Autenticación mediante Service Account JSON Key almacenada en GitHub Secrets.

Terraform Apply: Despliegue idempotente de los datasets en BigQuery (us-central1).

Raw Data Ingestion: Ingesta de 5,000 usuarios, 3,000 suscripciones y 50,000 transacciones.

dbt Execution: Compilación de modelos SQL, resolución de dependencias y materialización en BigQuery.