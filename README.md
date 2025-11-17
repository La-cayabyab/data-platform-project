## Data Platform Project

This personal project aims to simulate a light footprint data analytics infrastructure using free-tier enterprise data apps:
* Docker [containers for some apps & environments]
    * Kestra [orchestration]
    * Terraform [IaC]
* Google Cloud Platform [Service Accounts/IAM, DWH, object storage]
* Fivetran [GCS -> BQ Sync]
* dbt cloud [data transformation & orchestration]
* Looker Studio [data viz]
* Github [repo & PR CI]

![workflow](utils/flow.png)

### Learnings:
Terraform <> Fivetran - The building of resources was straightforward. However there are a few gaps that I encountered:
* Initial configuration of destination and connection requires a user to interact with Fivetran's web based UI i.e. testing the connection
* Some connection attributes codified in Terraform do not seem to propagate through to Fivetran. e.g. base path for targeting specific datasets in GCS bucket
* Some table stakes connection attributes _cannot_ be codified e.g. sync schedule

I eventually kept running into trial-end issues for the free tier version of apps i.e. API keys no longer work or no longer can be provisioned.

### Stuff I would still want to work on:
* Codify dbt jobs and integrate PR CI test coverage
* Spin up a Lightdash container (or something similar) and utilize its semantic layer and data viz functionalities
* Build out more tests for the pipeline and setup observability
* Experiment with hosted Airflow. I started to spin up GCP Airflow Composer resources (via Terraform) but the daily cost was high-ish for the trial account and I didn't want to run out of credits for the period.

## Project Artifacts

### Configuration high-level approach:
1. Build containers for Terraform and Kestra
2. Provision GCP and Fivetran resources (Service accounts, DWH, bucket, Fivetran destination/connections, etc.) via Terraform
3. Create python scripts for extracting/loading data into GCS bucket
4. Create Kestra workflow to trigger/auto-run python scripts and Fivetran GCS -> BQ sync
5. Configure dbt env and build sample transformed data models
6. Deploy and orchestrate Kestra workflows (ELT)
7. Visualize materialized data models in BQ via Looker Studio

### Requirements
* Docker MacOS App
* dbt cloud / CLI
* Terraform Docker image
* Kestra Docker image
* gcloud CLI
* GCP account
* Fivetran account
* Github account
* Homebrew [optional]

### Environment Variables

| Name                           | Description                                                 |
|--------------------------------|-------------------------------------------------------------|
| terraform-service-account      | `Private key` - Used for spinning up GCP/Fivetran resources |
| dbt-service-account            | `Private key` - Used for connecting dbt env to BQ (DWH)     |
| fivetran_api_key               | Used to auth & deploy Fivetran resources and trigger syncs  |
| fivetran_api_secret            | Used to auth & deploy Fivetran resources and trigger syncs  | 
| fivetran_connector_id (s)      | Used to identify connectors to trigger syncs                | 
| SECRET_PATH                    | Local path to secret keys                                   | 
| GOOGLE_APPLICATION_CREDENTIALS | Set in local .zshrc file for auth'ing Terraform against GCP | 

### Project Structure

```
repo
├── data-ingestion/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── main.py
│   └── src/
│       ├── common/
│       │   ├── config.py
│       │   ├── data_io_classes.py
│       │   └── ingest_pipeline.py
│       └── endpoint_extractor/
│           ├── comments_extractor.py
│           ├── posts_extractor.py
│           └── users_extractor.py
├── dbt/
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── base/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── exposure/
│   ├── macros/
├── infrastructure/
│   ├── main.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   ├── modules/
│   │   ├── fivetran/
│   │   └── gcp/
├── orchestration/
│   ├── workflows/
│   │   ├── data_extract.yml
│   │   ├── data_pipeline.yml
│   │   ├── fivetran_load.yml
│   │   └── run_data_ingestion.yml
│   └── data/
├── utils/
│   └── tfstate_cleanup.sh
├── docker-compose.yml
└── README.md
```