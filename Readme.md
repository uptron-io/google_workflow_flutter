# Google Workflows Supabase Flutter

Приветствую вас! Этот репозиторий представляет собой простой пример системы управления документами.

## Клонирование репозитория

Чтобы склонировать репозиторий, выполните следующую команду в вашем терминале:

```bash
git clone https://github.com/uptron-io/google_workflow_flutter
```

## Установка зависимостей

Перейдите в корневую папку flutter проекта и выполните команду установки зависимостей:
```bash
flutter pub get
```

## Чтобы развернуть workflows в Google Cloud, выполните следующие шаги:
1. Установите и настройте [Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
2. Запустите следующие команды в командной строке:
```bash
# Создание секретов Supabase URL и Supabase Anonymous Key
gcloud secrets create SUPABASE_URL --replication-policy="user-managed" --locations=europe-west4
gcloud secrets create SUPABASE_ANON_KEY --replication-policy="user-managed" --locations=europe-west4

# Добавление данных в секреты Supabase URL и Supabase Anonymous Key
gcloud secrets versions add SUPABASE_URL --data-file=<(echo -n "supabase_url")
gcloud secrets versions add SUPABASE_ANON_KEY --data-file=<(echo -n "supabase_anon_key")

# Деплой workflows
gcloud workflows deploy sys_confirmation_by_role --source google/workflow/_utils/sys_confirmation_by_role.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
gcloud workflows deploy sys_close_process --source google/workflow/_utils/sys_close_process.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
gcloud workflows deploy init_supabase --source google/workflow/_utils/init_supabase.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
gcloud workflows deploy sys_reject_process --source=_utils/sys_reject_process.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com
gcloud workflows deploy main_process --source google/workflow/main_process.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
```

## Запуск Flutter проекта

Перейдите в папку app и введите команду:

```bash
flutter run
```

## Запуск Supabase проекта

Перейдите в папку supabase и введите команду:

```bash
supabase start
```
## Google Workflows Supabase Flutter

Welcome! This repository represents a simple example of a document management system.

## Cloning the Repository
To clone the repository, execute the following command in your terminal:
```bash 
git clone https://github.com/uptron-io/google_workflow_flutter
```

## Installing Dependencies
Navigate to the root folder of the Flutter project and execute the dependency installation command:
```bash 
flutter pub get
```

## Deploying Workflows to Google Cloud
To deploy workflows to Google Cloud, follow these steps:
1. Install and configure [Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
2. Run the following commands in your terminal:
```bash
# Creating Supabase URL and Supabase Anonymous Key secrets
gcloud secrets create SUPABASE_URL --replication-policy="user-managed" --locations=europe-west4
gcloud secrets create SUPABASE_ANON_KEY --replication-policy="user-managed" --locations=europe-west4

# Adding data to Supabase URL and Supabase Anonymous Key secrets
gcloud secrets versions add SUPABASE_URL --data-file=<(echo -n "supabase_url")
gcloud secrets versions add SUPABASE_ANON_KEY --data-file=<(echo -n "supabase_anon_key")

# Deploying workflows
gcloud workflows deploy sys_confirmation_by_role --source google/workflow/_utils/sys_confirmation_by_role.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
gcloud workflows deploy sys_close_process --source google/workflow/_utils/sys_close_process.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
gcloud workflows deploy init_supabase --source google/workflow/_utils/init_supabase.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
gcloud workflows deploy sys_reject_process --source=_utils/sys_reject_process.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com
gcloud workflows deploy main_process --source google/workflow/main_process.yaml --service-account=your_service_account@your_project_name.iam.gserviceaccount.com --location europe-west4
```

## Running the Flutter Project
Navigate to the app folder and execute the command:
```shell
flutter run
```

## Running the Supabase Project
Navigate to the supabase folder and execute the command:
```shell
supabase start
```
