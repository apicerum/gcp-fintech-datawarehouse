# 🚀 GCP Fintech Data Warehouse (End-to-End ELT Pipeline)

Un Data Warehouse moderno para el sector Fintech implementado en **Google Cloud Platform (GCP)**. El proyecto automatiza la infraestructura como código (IaC), la ingesta de datos sintéticos, la transformación ELT en capas mediante **dbt**, la generación de documentación interactiva en **GitHub Pages** y la visualización analítica en **Looker Studio**, todo coordinado mediante **GitHub Actions**.

---

## 🏗 Architecture & Data Lineage

```text
[ Terraform (GCS Backend) ] ──> GCP Infrastructure Provisioning (Datasets & Storage)
                               │
[ Python + Faker ]         ──> Ingesta Raw (WRITE_TRUNCATE) ──> BigQuery: fintech_raw_dev
                               │
[ dbt Core + CI/CD ]        ──> Data Modeling & Transformation        │
├── Staging (Views)  ──────────────┘ ──> BigQuery: fintech_staging_dev
└── Marts (Tables)   ──────────────────> BigQuery: fintech_marts_dev
                                         │
[ Looker Studio ]    <───────────────────┴──> Dashboard Analítico (GMV, AOV, Geo)

🛠 Tech Stack
Cloud Provider: Google Cloud Platform (BigQuery, Cloud Storage, IAM).

Infrastructure as Code (IaC): Terraform (con estado remoto en GCS).

Data Processing & Seeding: Python 3.11, Pandas, PyArrow, Faker, BigQuery Client.

Data Transformation & Docs: dbt Core (dbt-bigquery), dbt docs.

CI/CD Orchestration: GitHub Actions & GitHub Pages.

Business Intelligence: Looker Studio.

📂 Project Structure
Plaintext
.
├── .github/workflows/
│   └── deploy-dev.yml         # GitHub Actions CI/CD Pipeline (Terraform + dbt + Pages)
├── docs/
│   └── images/                # Capturas de evidencia y diagramas para el repositorio
│       └── dashboard_looker.png
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
Tablas crudas cargadas mediante Python (WRITE_TRUNCATE):

raw_users

raw_subscriptions

raw_transactions

Layer 2: Staging (fintech_staging_dev)
Vistas de limpieza de nombres, casteo de tipos numéricos/timestamps, estandarización de ISOs y filtrado de estados.

Layer 3: Marts (fintech_marts_dev)
Tablas de hechos y dimensiones optimizadas para consumo analítico:

dim_users: Vista 360 del usuario combinando métricas acumuladas de consumo, estado de actividad y perfil demográfico.

fct_transactions: Eventos transaccionales enriquecidos con contexto geográfico y desgloses temporales.

📈 Business Intelligence & Analytics (Looker Studio)
El Data Warehouse alimenta un cuadro de mando analítico en Looker Studio conectado en tiempo real a la capa fintech_marts_dev.

Métricas Clave Monitoreadas (English Specs):
Total Completed GMV: Volumen bruto de mercancía transaccionado en estado COMPLETED.

Total Transactions & AOV (Average Order Value): Monitoreo de volumen de operaciones y ticket medio por transacción.

Geographic Distribution: Mapa coroplético interactivo por código de país (country_code).

Time Series Breakdown: Evolución temporal por tipo de operación (PAYMENT, TRANSFER, WITHDRAWAL, DEPOSIT).

📚 Interactive Documentation & Lineage
La documentación del proyecto, catálogo de datos y grafo de linaje generado por dbt docs se compila y despliega automáticamente en GitHub Pages.

🔗 Live dbt Docs: https://apicerum.github.io/gcp-fintech-datawarehouse/

⚙️ CI/CD Deployment Flow (GitHub Actions)
El workflow se activa de forma automática tras cada push a la rama main:

Autenticación en GCP: Autenticación segura mediante Service Account JSON Key almacenada en GitHub Secrets.

Terraform Apply: Despliegue idempotente de los datasets en BigQuery (us-central1).

Raw Data Ingestion: Ingesta sintética de usuarios, suscripciones y transacciones mediante Python.

dbt Execution & Testing: Compilación de modelos SQL, resolución de dependencias, materialización en BigQuery y ejecución de tests.

dbt Docs Publish: Compilación de artifacts del sitio estático (target/) y publicación automatizada en GitHub Pages.