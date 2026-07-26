# EUB Connect

EUB Connect is a Flutter/GetX local demo portal inspired by European University of Bangladesh workflows. It is not an official production EUB system. The current build runs from local `DemoStore` / `DemoSeed` / GetStorage data and does not require Firebase, Supabase, a REST backend, remote authentication, or cloud storage.

## Current Demo Status

- Serious university portal demo for Student, Teacher, Administration, and Admin roles
- Local persistence through GetStorage with reset support
- Data-driven dashboards, management records, search/filter/sort lists, detail dialogs, and cross-role demo actions
- Supabase files remain as future backend scaffolding only

## Roles

| Role | Purpose |
| --- | --- |
| Student | Personal courses, attendance, assignments, quiz, results, finance, requests, support, events, clubs, community, lost/found, profile |
| Teacher | Assigned sections, attendance, assignments, quizzes, submissions, grading, materials, notices, results, support |
| Administration | Office staff workflows for registrar, accounts, examinations, admission/student affairs, IQAC, ICT, proctor, CCC, and other operational units |
| Admin | University-wide command center, system oversight, people/academic/finance/operations/support/moderation/settings |

## Demo Credentials

All demo accounts use password `123456`.

| Role | ID | Email | Name |
| --- | --- | --- | --- |
| Student | `2023001001` | `student@eub.edu.bd` | Nayem Ahmed |
| Teacher | `T1001` | `teacher@eub.edu.bd` | Dr. Farhan Rahman |
| Administration | `EUB-REG-1001` | `administration@eub.edu.bd` | Md. Rakib Hasan |
| Admin | `ADMIN001` | `admin@eub.edu.bd` | System Administrator |

## Architecture

```text
lib/core/demo/demo_models.dart   # local demo models
lib/core/demo/demo_seed.dart     # deterministic interconnected seed data
lib/core/demo/demo_store.dart    # local repository, calculations, mutations
lib/feature/home/                # role dashboards, navigation, generic management/detail UI
```

## Feature Matrix

- Academic: departments, programs, courses, sections, calendar, routine, attendance, assignments, quizzes, results, examinations
- People: students, teachers, administration staff, user roles
- Operations: admissions, student requests/documents, support tickets, complaints/cases
- Finance: student ledgers, invoices, payments, scholarships/waivers
- Engagement: notices, events, clubs, discussion board, community moderation, lost & found
- System: notifications, activity log, settings, demo data reset

## Local Demo Data

The seed contains students, teachers, administration staff, offices, departments, programs, courses, sections, enrollments, attendance, assignments, submissions, quizzes, exams, invoices, payments, admissions, requests, notices, events, clubs, forum reports, support tickets, lost/found cases, notifications, approvals, and audit activity. Dashboard numbers are calculated from these records.

## Cross-Role Workflows

- Teacher publishes or grades assignments -> students receive updates
- Student submits assignments/quizzes -> teacher views submissions/attempts
- Student pays locally -> invoice due, payments, finance totals, and notifications update
- Student creates requests/support tickets -> Administration/Admin queues update
- Administration processes requests/tickets/results -> student status and notifications update
- Admin/Administration creates notices/events -> targeted users see records/notifications
- Student reports forum content -> Admin moderation count updates
- Admin resolves reports or lost/found cases -> local records update immediately

## Run

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
dart format .
flutter analyze
flutter test
```

## Backend Future Plan

The app is intentionally frontend/local-demo first. A future backend can replace `DemoStore` with Supabase/API repositories while preserving the role model, UI modules, and workflow contracts.
