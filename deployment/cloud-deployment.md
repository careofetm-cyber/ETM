# Google Cloud Platform Deployment

## 1. Prerequisites

- Google Cloud account
- gcloud CLI installed
- Firebase project configured

## 2. Backend Deployment (Cloud Run)

```bash
# Set project
gcloud config set project YOUR_PROJECT_ID

# Build and push Docker image
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/etm-backend

# Deploy to Cloud Run
gcloud run deploy etm-backend \
  --image gcr.io/YOUR_PROJECT_ID/etm-backend \
  --platform managed \
  --region asia-south1 \
  --allow-unauthenticated \
  --set-env-vars DB_HOST=YOUR_DB_HOST,DB_PORT=5432,DB_NAME=etm_database
```

## 3. Database (Cloud SQL)

```bash
# Create PostgreSQL instance
gcloud sql instances create etm-postgres \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=asia-south1

# Create database
gcloud sql databases create etm_database --instance=etm-postgres

# Create user
gcloud sql users create postgres \
  --instance=etm-postgres \
  --password=YOUR_PASSWORD
```

## 4. Admin Web (Firebase Hosting)

```bash
# Build web app
cd apps/admin_web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## 5. Firebase Services

### Enable Firebase Services:
- Cloud Messaging (Push Notifications)
- Authentication
- Cloud Firestore (Optional)

### Configure Firebase CLI:
```bash
npm install -g firebase-tools
firebase login
firebase init
```
