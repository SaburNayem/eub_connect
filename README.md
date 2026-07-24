# EUB Connect

EUB Connect is a Flutter/GetX university management demo for students, teachers, faculty staff, and administrators. The active app now runs in local demo mode first: login, dashboards, assignments, quizzes, attendance, payments, events, support, forum data, approvals, notifications, and settings are powered by a shared local dataset.

## Stack

- Flutter and Dart
- GetX for routing/state
- GetStorage for local demo persistence
- Material 3
- Supabase files are kept as future backend scaffolding, but are not required to run the demo

## Demo Accounts

All demo accounts use password `123456`. Login accepts either ID or email.

| Role | ID | Email | Name |
| --- | --- | --- | --- |
| Student | `2023001001` | `student@eub.edu.bd` | Nayem Ahmed |
| Teacher | `T1001` | `teacher@eub.edu.bd` | Dr. Farhan Rahman |
| Faculty | `F1001` | `faculty@eub.edu.bd` | Md. Rakib Hasan |
| Admin | `ADMIN001` | `admin@eub.edu.bd` | System Administrator |

The login screen includes a demo account picker that fills the selected ID and password.

## Demo Data

The local dataset lives under:

```text
lib/core/demo/
```

It includes:

- 180 students, 10 teachers, faculty/admin users
- 5 departments and 15 courses
- sections, enrollments, weekly routines, rooms, and attendance history
- 15 assignments, student submissions, teacher grading, 10 quizzes, quiz attempts
- 20 notices, 10 events, clubs, scholarships, 80 invoices, 99 payments, 427 result rows
- 24 forum posts, 72 comments/replies, moderation reports
- support tickets, notifications, approvals, and 40 activity entries

Important counters are calculated from these collections. For example, forum post/comment counts come from the forum lists, attendance percentages come from attendance rows, and tuition due comes from invoice/payment records.

## Local Workflows

Local demo state persists with GetStorage and survives app restart where practical.

Implemented cross-role examples:

- Teacher publishes/grades assignment -> student sees assignment/grade/notification
- Student submits assignment -> teacher sees submission
- Student submits quiz -> teacher sees attempt
- Teacher marks attendance -> student attendance screen updates
- Student pays invoice through a local payment simulation -> invoice due and payment history update
- Student creates forum report -> admin/faculty moderation sees it
- Student creates forum posts through a validated form
- Student creates support ticket through category/priority/description form -> faculty/admin can reply
- Teacher publishes quizzes with entered questions/options/correct answers
- Event registration, club join, approvals, notices, notifications, and reset actions update local state

Settings includes `Reset Demo Data`, which restores the original seed.

## Run

```bash
flutter pub get
flutter run
```

No Supabase credentials are required for the current demo version.

## Future Backend

The previous Supabase foundation remains in:

```text
lib/core/backend/
lib/core/config/
supabase/
```

Those files are not active in app startup now. They can be used later to replace demo repositories with API/Supabase repositories without rebuilding screens from scratch.

## Quality Checks

```bash
dart format .
flutter analyze
flutter test
```

Current tests cover GPA, attendance percentage, tuition due, quiz scoring, and schedule conflict calculations.
