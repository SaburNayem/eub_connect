# EUB Connect

EUB Connect is a Flutter application for a university management system. The project is organized with a feature-first folder structure so each module can be completed step by step without changing the existing folder layout.

This README documents the folders that already exist under `lib` and the expected file names to use when completing each feature. When adding new work, reuse these folders instead of creating duplicate folders.

## Current Status

- Login and registration currently have Dart controller, model, and screen files.
- Auth shared UI widgets already exist inside `feature/auth/widget`.
- Common, faculty, teacher, student, and home feature folders are already prepared for future work.
- Empty folders are intentional placeholders. Add the listed files there when completing each feature.

## Technology Stack

- Flutter
- Dart
- GetX
- Material Design 3

## Run Project

```bash
flutter pub get
flutter run
```

## Architecture

The project follows a feature-first structure.

```text
feature_name/
  controller/
    feature_name_controller.dart
  model/
    feature_name_model.dart
  screen/
    feature_name_screen.dart
```

Shared app-level code stays inside `core`, while each feature keeps its own controller, model, and screen folders.

## Current Lib Folder Structure

```text
lib
|   app.dart
|   main.dart
|
+---app_route
+---core
|   +---constant
|   |   +---app_color
|   |   |       app_colors.dart
|   |   |
|   |   +---icon_path
|   |   \---image_path
|   +---data
|   +---routes
|   |       app_pages.dart
|   |       app_routes.dart
|   |
|   \---widget
\---feature
    +---auth
    |   +---login
    |   |   +---controller
    |   |   |       login_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       login_model.dart
    |   |   |
    |   |   \---screen
    |   |           login_screen.dart
    |   +---registration
    |   |   +---controller
    |   |   |       registration_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       registration_model.dart
    |   |   |
    |   |   \---screen
    |   |       |   registration_screen.dart
    |   |       |
    |   |       \---widget
    |   |               photo_field.dart
    |   +---screen
    |   |       auth_screen.dart
    |   |
    |   \---widget
    |           auth_panel.dart
    |           auth_switcher.dart
    |           auth_text_field.dart
    |           brand_header.dart
    +---common
    |   +---depertment_facalty_info
    |   |   +---controller
    |   |   |       depertment_facalty_info_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       depertment_facalty_info_model.dart
    |   |   |
    |   |   \---screen
    |   |           depertment_facalty_info_screen.dart
    |   +---event_management
    |   |   +---controller
    |   |   |       event_management_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       event_management_model.dart
    |   |   |
    |   |   \---screen
    |   |           event_management_screen.dart
    |   +---lost_found_section
    |   |   +---controller
    |   |   |       lost_found_section_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       lost_found_section_model.dart
    |   |   |
    |   |   \---screen
    |   |           lost_found_section_screen.dart
    |   +---notice
    |   |   +---controller
    |   |   |       notice_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       notice_model.dart
    |   |   |
    |   |   \---screen
    |   |           notice_screen.dart
    |   \---settings
    |       +---controller
    |       |       settings_controller.dart
    |       |
    |       +---model
    |       |       settings_model.dart
    |       |
    |       \---screen
    |               settings_screen.dart
    +---facalty
    |   +---academic_calander_management
    |   |   +---controller
    |   |   |       academic_calander_management_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       academic_calander_management_model.dart
    |   |   |
    |   |   \---screen
    |   |           academic_calander_management_screen.dart
    |   +---admin_facalty
    |   |   +---controller
    |   |   |       admin_facalty_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       admin_facalty_model.dart
    |   |   |
    |   |   \---screen
    |   |           admin_facalty_screen.dart
    |   +---depertment_management
    |   |   +---controller
    |   |   |       depertment_management_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       depertment_management_model.dart
    |   |   |
    |   |   \---screen
    |   |           depertment_management_screen.dart
    |   +---payment
    |   |   +---controller
    |   |   |       payment_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       payment_model.dart
    |   |   |
    |   |   \---screen
    |   |           payment_screen.dart
    |   +---result_academic_report
    |   |   +---controller
    |   |   |       result_academic_report_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       result_academic_report_model.dart
    |   |   |
    |   |   \---screen
    |   |           result_academic_report_screen.dart
    |   +---routine_management
    |   |   +---controller
    |   |   |       routine_management_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       routine_management_model.dart
    |   |   |
    |   |   \---screen
    |   |           routine_management_screen.dart
    |   +---student_management
    |   |   +---controller
    |   |   |       student_management_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       student_management_model.dart
    |   |   |
    |   |   \---screen
    |   |           student_management_screen.dart
    |   +---system_activity
    |   |   +---controller
    |   |   |       system_activity_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       system_activity_model.dart
    |   |   |
    |   |   \---screen
    |   |           system_activity_screen.dart
    |   +---teacher
    |   |   +---academic_report
    |   |   |   +---controller
    |   |   |   |       academic_report_controller.dart
    |   |   |   |
    |   |   |   +---model
    |   |   |   |       academic_report_model.dart
    |   |   |   |
    |   |   |   \---screen
    |   |   |           academic_report_screen.dart
    |   |   +---dashboard
    |   |   |   +---controller
    |   |   |   |       dashboard_controller.dart
    |   |   |   |
    |   |   |   +---model
    |   |   |   |       dashboard_model.dart
    |   |   |   |
    |   |   |   \---screen
    |   |   |           dashboard_screen.dart
    |   |   +---manage_course
    |   |   |   +---assignment_and_quiz
    |   |   |   |   +---controller
    |   |   |   |   |       assignment_and_quiz_controller.dart
    |   |   |   |   |
    |   |   |   |   +---model
    |   |   |   |   |       assignment_and_quiz_model.dart
    |   |   |   |   |
    |   |   |   |   \---screen
    |   |   |   |           assignment_and_quiz_screen.dart
    |   |   |   +---attendence_management
    |   |   |   |   +---controller
    |   |   |   |   |       attendence_management_controller.dart
    |   |   |   |   |
    |   |   |   |   +---model
    |   |   |   |   |       attendence_management_model.dart
    |   |   |   |   |
    |   |   |   |   \---screen
    |   |   |   |           attendence_management_screen.dart
    |   |   |   +---lecture_materials
    |   |   |   |   +---controller
    |   |   |   |   |       lecture_materials_controller.dart
    |   |   |   |   |
    |   |   |   |   +---model
    |   |   |   |   |       lecture_materials_model.dart
    |   |   |   |   |
    |   |   |   |   \---screen
    |   |   |   |           lecture_materials_screen.dart
    |   |   |   \---marks_result
    |   |   |       +---controller
    |   |   |       |       marks_result_controller.dart
    |   |   |       |
    |   |   |       +---model
    |   |   |       |       marks_result_model.dart
    |   |   |       |
    |   |   |       \---screen
    |   |   |               marks_result_screen.dart
    |   |   \---notice_for_student
    |   |       +---controller
    |   |       |       notice_for_student_controller.dart
    |   |       |
    |   |       +---model
    |   |       |       notice_for_student_model.dart
    |   |       |
    |   |       \---screen
    |   |               notice_for_student_screen.dart
    |   +---teacher_management
    |   |   +---controller
    |   |   |       teacher_management_controller.dart
    |   |   |
    |   |   +---model
    |   |   |       teacher_management_model.dart
    |   |   |
    |   |   \---screen
    |   |           teacher_management_screen.dart
    |   \---user_role_management
    |       +---controller
    |       |       user_role_management_controller.dart
    |       |
    |       +---model
    |       |       user_role_management_model.dart
    |       |
    |       \---screen
    |           user_role_management_screen.dart
    +---home
    |   +---model
    |   |       static_feature.dart
    |   |
    |   \---screen
    |           home_screen.dart
    \---student
        +---assingment
        |   +---controller
        |   |       assingment_controller.dart
        |   |
        |   +---model
        |   |       assingment_model.dart
        |   |
        |   \---screen
        |           assingment_screen.dart
        +---attendance_tracking
        |   +---controller
        |   |       attendance_tracking_controller.dart
        |   |
        |   +---model
        |   |       attendance_tracking_model.dart
        |   |
        |   \---screen
        |           attendance_tracking_screen.dart
        +---class_routine_schedule
        |   +---controller
        |   |       class_routine_schedule_controller.dart
        |   |
        |   +---model
        |   |       class_routine_schedule_model.dart
        |   |
        |   \---screen
        |           class_routine_schedule_screen.dart
        +---club_community
        |   +---controller
        |   |       club_community_controller.dart
        |   |
        |   +---model
        |   |       club_community_model.dart
        |   |
        |   \---screen
        |           club_community_screen.dart
        +---event
        |   +---controller
        |   |       event_controller.dart
        |   |
        |   +---model
        |   |       event_model.dart
        |   |
        |   \---screen
        |           event_screen.dart
        +---exam_result
        |   +---controller
        |   |       exam_result_controller.dart
        |   |
        |   +---model
        |   |       exam_result_model.dart
        |   |
        |   \---screen
        |           exam_result_screen.dart
        +---payment_history
        |   +---controller
        |   |       payment_history_controller.dart
        |   |
        |   +---model
        |   |       payment_history_model.dart
        |   |
        |   \---screen
        |           payment_history_screen.dart
        +---profile
        |   +---controller
        |   |       profile_controller.dart
        |   |
        |   +---model
        |   |       profile_model.dart
        |   |
        |   \---screen
        |           profile_screen.dart
        +---quiz_practice
        |   +---controller
        |   |       quiz_practice_controller.dart
        |   |
        |   +---model
        |   |       quiz_practice_model.dart
        |   |
        |   \---screen
        |           quiz_practice_screen.dart
        +---scholershi_info
        |   +---controller
        |   |       scholershi_info_controller.dart
        |   |
        |   +---model
        |   |       scholershi_info_model.dart
        |   |
        |   \---screen
        |           scholershi_info_screen.dart
        +---semester_course_info
        |   +---controller
        |   |       semester_course_info_controller.dart
        |   |
        |   +---model
        |   |       semester_course_info_model.dart
        |   |
        |   \---screen
        |           semester_course_info_screen.dart
        +---student_discussion_forum
        |   +---controller
        |   |       student_discussion_forum_controller.dart
        |   |
        |   +---model
        |   |       student_discussion_forum_model.dart
        |   |
        |   \---screen
        |           student_discussion_forum_screen.dart
        +---student_support
        |   +---controller
        |   |       student_support_controller.dart
        |   |
        |   +---model
        |   |       student_support_model.dart
        |   |
        |   \---screen
        |           student_support_screen.dart
        \---tution_fee
            +---controller
            |       tution_fee_controller.dart
            |
            +---model
            |       tution_fee_model.dart
            |
            \---screen
                    tution_fee_screen.dart
```

## Authentication Feature

Authentication is the active feature area at the moment. It is divided into `login` and `registration`.

### Login

Path:

```text
lib/feature/auth/login
```

Current files:

- `controller/login_controller.dart` manages the student ID and password text controllers.
- `model/login_model.dart` stores login form data with `studentId` and `password`.
- `screen/login_screen.dart` contains the login UI.

### Registration

Path:

```text
lib/feature/auth/registration
```

Current files:

- `controller/registration_controller.dart` manages student ID, full name, password, phone number, email address, and photo path data.
- `model/registration_model.dart` stores registration form data.
- `screen/registration_screen.dart` contains the registration UI.
- `screen/widget/photo_field.dart` contains the registration photo field widget.

## Existing Feature Areas

- `feature/auth` contains login and registration.
- `feature/common` contains shared university features such as department/faculty information, events, lost and found, notices, and settings.
- `feature/facalty` contains faculty/admin management folders and teacher-related folders.
- `feature/student` contains student workflow folders such as assignment, attendance, routine, community, event, result, payment, profile, quiz, scholarship, course, discussion, support, and tuition fee.
- `feature/home` is available for the app home area.

## Project Entry Points

- `lib/main.dart` starts the Flutter application.
- `lib/app.dart` configures `GetMaterialApp`, theme settings, routes, and the initial route.
- `lib/core/constant/app_color/app_colors.dart` stores the app color constants.

## Development Rule

This folder structure already exists in the project. When completing a feature, add or update files inside the matching existing folder instead of creating a new duplicate folder.

Keep the current folder names unchanged unless the whole project is intentionally renamed and every import is updated together.

## Future Work

- Complete login and registration UI screens inside the existing `screen` folders.
- Complete route files inside the existing `core/routes` folder.
- Add controllers, models, and screens inside the existing common, faculty, teacher, student, and home folders as each feature is developed.
- Add tests for completed features.

## Contributing

1. Create a new branch for your work.
2. Reuse the existing feature folders.
3. Keep feature code inside its own module.
4. Run formatting and tests before opening a pull request.

## License

This project is intended for educational and university management use.
