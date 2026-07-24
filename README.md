# EUB Connect

EUB Connect is a Flutter/GetX university management app for students, teachers, faculty staff, and administrators. The project keeps the existing feature-first folder structure while moving operational data to Supabase/PostgreSQL.

## Stack

- Flutter and Dart
- GetX for routing/state
- Supabase Auth
- Supabase PostgreSQL with RLS
- Supabase Storage
- Material 3

## Environment

Copy `.env.example` for reference, but pass secrets through `--dart-define` for Flutter builds:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-public-anon-key \
  --dart-define=SUPABASE_STORAGE_BUCKET=app-files
```

Do not commit service-role keys or production credentials.

## Supabase Setup

Install the Supabase CLI, link your project, then apply migrations:

```bash
supabase login
supabase link --project-ref your-project-ref
supabase db push
```

Schema files live in:

```text
supabase/migrations/
```

Optional development seed data lives in:

```text
supabase/seed/dev_seed.sql
```

Seed data is intentionally outside Flutter source. The app should show empty states when the database has no records.

## Implemented Backend Foundation

- Supabase initialization in `lib/core/backend/supabase_backend.dart`
- Environment parsing in `lib/core/config/app_environment.dart`
- Shared app result/error types in `lib/core/backend/app_failure.dart`
- Shared loading/empty/error panels in `lib/core/ui/state_panels.dart`
- Normalized database schema and RLS policies for profiles, roles, academic data, assignments, quizzes, attendance, results, notices, events, forum, support, tuition, lost/found, approvals, audit logs, and settings
- Storage bucket and policies for protected uploads
- Supabase Auth login/session restoration
- Public registration creates student accounts only; teacher/faculty/admin roles must be assigned by an admin

## Migrated Features

- Home feature registry is now metadata-only. It no longer stores dashboard counts, fake records, or operational activity.
- Home dashboard metrics load from the database aggregate view and show loading/error/empty states.
- Student assignments load from Supabase, support filtering by enrolled section, and persist submissions.
- Student quizzes load from Supabase, show actual questions/options, and persist attempts.
- Teacher/faculty assignment and quiz management loads from Supabase, publishes assignments/quizzes, lists submissions/attempts, and persists grading.
- Static role login accounts were removed.

## Remaining Work

Several existing modules still render through the shared feature placeholder wrapper while their database tables now exist. They need dedicated repositories/controllers/screens connected to the schema:

- attendance management persistence UI
- profile edit/photo upload
- class routine from `class_schedules`
- events, notices, lost/found CRUD
- forum post/comment/reaction/report flows
- support ticket conversation UI
- tuition/payment provider integration
- faculty/admin CRUD screens and audit workflows

## Run

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

Without Supabase configuration, the app builds and shows backend-not-configured states rather than fake data.

## Test

```bash
dart format .
flutter analyze
flutter test
```

Current tests cover core GPA, attendance, tuition, quiz scoring, and schedule conflict calculations.
