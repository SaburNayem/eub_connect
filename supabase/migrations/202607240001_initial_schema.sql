-- EUB Connect production schema.
-- Run with Supabase CLI: supabase db push

create extension if not exists "pgcrypto";

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  university_id text unique not null,
  full_name text not null,
  email text unique not null,
  phone text,
  address text,
  emergency_contact text,
  profile_photo_path text,
  status text not null default 'active' check (status in ('pending','active','inactive','suspended')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.roles (
  id uuid primary key default gen_random_uuid(),
  code text unique not null check (code in ('student','teacher','faculty','admin')),
  name text not null
);

create table public.user_roles (
  user_id uuid not null references public.profiles(id) on delete cascade,
  role_id uuid not null references public.roles(id) on delete cascade,
  assigned_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  primary key (user_id, role_id)
);

create table public.faculties (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  code text unique not null,
  status text not null default 'active' check (status in ('active','inactive')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.departments (
  id uuid primary key default gen_random_uuid(),
  faculty_id uuid references public.faculties(id) on delete set null,
  name text not null,
  code text unique not null,
  contact_email text,
  status text not null default 'active' check (status in ('active','inactive')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.programs (
  id uuid primary key default gen_random_uuid(),
  department_id uuid not null references public.departments(id) on delete cascade,
  name text not null,
  code text not null,
  degree_level text not null default 'undergraduate',
  total_semesters integer not null check (total_semesters > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (department_id, code)
);

create table public.semesters (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  starts_at date not null,
  ends_at date not null,
  status text not null default 'draft' check (status in ('draft','active','published','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_at > starts_at)
);

create table public.students (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid unique not null references public.profiles(id) on delete cascade,
  student_no text unique not null,
  department_id uuid references public.departments(id),
  program_id uuid references public.programs(id),
  current_semester_id uuid references public.semesters(id),
  section text,
  batch text,
  cgpa numeric(4,2) check (cgpa is null or (cgpa >= 0 and cgpa <= 4)),
  status text not null default 'active' check (status in ('active','inactive','graduated','probation','suspended')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.teachers (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid unique not null references public.profiles(id) on delete cascade,
  employee_no text unique not null,
  department_id uuid references public.departments(id),
  designation text,
  status text not null default 'active' check (status in ('active','inactive','on_leave')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.staff (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid unique not null references public.profiles(id) on delete cascade,
  employee_no text unique not null,
  department_id uuid references public.departments(id),
  designation text,
  staff_type text not null check (staff_type in ('faculty','admin')),
  status text not null default 'active' check (status in ('active','inactive','on_leave')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.courses (
  id uuid primary key default gen_random_uuid(),
  department_id uuid references public.departments(id),
  code text unique not null,
  title text not null,
  credits numeric(3,1) not null check (credits > 0),
  course_type text not null default 'theory' check (course_type in ('theory','lab','project','seminar')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.course_sections (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  semester_id uuid not null references public.semesters(id) on delete cascade,
  section_code text not null,
  capacity integer check (capacity is null or capacity > 0),
  status text not null default 'draft' check (status in ('draft','active','published','closed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (course_id, semester_id, section_code)
);

create table public.teacher_course_assignments (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid not null references public.teachers(id) on delete cascade,
  section_id uuid not null references public.course_sections(id) on delete cascade,
  role text not null default 'instructor' check (role in ('instructor','assistant','lab_instructor')),
  created_at timestamptz not null default now(),
  unique (teacher_id, section_id, role)
);

create table public.course_enrollments (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  section_id uuid not null references public.course_sections(id) on delete cascade,
  status text not null default 'enrolled' check (status in ('pending','enrolled','dropped','completed')),
  enrolled_at timestamptz not null default now(),
  unique (student_id, section_id)
);

create table public.rooms (
  id uuid primary key default gen_random_uuid(),
  building text not null,
  room_no text not null,
  capacity integer,
  room_type text not null default 'classroom' check (room_type in ('classroom','lab','auditorium','office')),
  unique (building, room_no)
);

create table public.class_schedules (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.course_sections(id) on delete cascade,
  teacher_id uuid references public.teachers(id),
  room_id uuid references public.rooms(id),
  day_of_week integer not null check (day_of_week between 1 and 7),
  starts_at time not null,
  ends_at time not null,
  class_type text not null default 'theory' check (class_type in ('theory','lab','exam','makeup')),
  status text not null default 'published' check (status in ('draft','published','cancelled')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_at > starts_at)
);

create table public.attendance_sessions (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.course_sections(id) on delete cascade,
  teacher_id uuid not null references public.teachers(id),
  session_date date not null,
  starts_at time,
  ends_at time,
  topic text,
  status text not null default 'open' check (status in ('open','submitted','locked')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (section_id, session_date, starts_at)
);

create table public.attendance_records (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.attendance_sessions(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  status text not null check (status in ('present','absent','late','excused')),
  note text,
  marked_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (session_id, student_id)
);

create table public.assignments (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.course_sections(id) on delete cascade,
  title text not null,
  instructions text,
  total_marks numeric(8,2) not null check (total_marks > 0),
  opens_at timestamptz,
  due_at timestamptz not null,
  status text not null default 'draft' check (status in ('draft','published','closed','archived')),
  allow_resubmission boolean not null default true,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.assignment_attachments (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.assignments(id) on delete cascade,
  file_name text not null,
  storage_path text not null,
  content_type text,
  size_bytes bigint check (size_bytes is null or size_bytes >= 0),
  uploaded_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.assignment_submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.assignments(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  note text,
  status text not null default 'submitted' check (status in ('draft','submitted','returned','graded','late')),
  submitted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (assignment_id, student_id)
);

create table public.assignment_submission_files (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid not null references public.assignment_submissions(id) on delete cascade,
  file_name text not null,
  storage_path text not null,
  content_type text,
  size_bytes bigint check (size_bytes is null or size_bytes >= 0),
  created_at timestamptz not null default now()
);

create table public.assignment_grades (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid unique not null references public.assignment_submissions(id) on delete cascade,
  marks numeric(8,2) not null check (marks >= 0),
  feedback text,
  graded_by uuid references public.profiles(id),
  graded_at timestamptz not null default now()
);

create table public.quizzes (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.course_sections(id) on delete cascade,
  title text not null,
  instructions text,
  duration_minutes integer not null check (duration_minutes > 0),
  total_marks numeric(8,2) not null check (total_marks > 0),
  opens_at timestamptz not null,
  closes_at timestamptz not null,
  attempt_limit integer not null default 1 check (attempt_limit > 0),
  show_result_immediately boolean not null default false,
  status text not null default 'draft' check (status in ('draft','published','closed','archived')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (closes_at > opens_at)
);

create table public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  quiz_id uuid not null references public.quizzes(id) on delete cascade,
  question_text text not null,
  question_type text not null default 'single_choice' check (question_type in ('single_choice','multiple_choice','short_answer')),
  marks numeric(8,2) not null check (marks > 0),
  sort_order integer not null default 0
);

create table public.quiz_options (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.quiz_questions(id) on delete cascade,
  option_text text not null,
  is_correct boolean not null default false,
  sort_order integer not null default 0
);

create table public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  quiz_id uuid not null references public.quizzes(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  attempt_no integer not null default 1,
  score numeric(8,2),
  status text not null default 'in_progress' check (status in ('in_progress','submitted','graded')),
  started_at timestamptz not null default now(),
  submitted_at timestamptz,
  unique (quiz_id, student_id, attempt_no)
);

create table public.quiz_answers (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references public.quiz_attempts(id) on delete cascade,
  question_id uuid not null references public.quiz_questions(id) on delete cascade,
  option_id uuid references public.quiz_options(id),
  answer_text text,
  awarded_marks numeric(8,2) check (awarded_marks is null or awarded_marks >= 0),
  unique (attempt_id, question_id)
);

create table public.results (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  semester_id uuid not null references public.semesters(id) on delete cascade,
  status text not null default 'draft' check (status in ('draft','published','withheld')),
  semester_gpa numeric(4,2) check (semester_gpa is null or (semester_gpa >= 0 and semester_gpa <= 4)),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (student_id, semester_id)
);

create table public.result_items (
  id uuid primary key default gen_random_uuid(),
  result_id uuid not null references public.results(id) on delete cascade,
  course_id uuid not null references public.courses(id),
  marks numeric(8,2) check (marks is null or marks >= 0),
  grade text,
  grade_point numeric(4,2) check (grade_point is null or (grade_point >= 0 and grade_point <= 4)),
  credits numeric(3,1) not null check (credits > 0),
  unique (result_id, course_id)
);

create table public.notices (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text not null,
  audience text not null default 'everyone' check (audience in ('everyone','students','teachers','faculty','admins','course_section','department')),
  department_id uuid references public.departments(id),
  section_id uuid references public.course_sections(id),
  published_at timestamptz,
  expires_at timestamptz,
  status text not null default 'draft' check (status in ('draft','published','expired','archived')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  location text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  status text not null default 'pending' check (status in ('draft','pending','approved','rejected','published','cancelled')),
  created_by uuid references public.profiles(id),
  approved_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_at is null or ends_at > starts_at)
);

create table public.event_registrations (
  event_id uuid not null references public.events(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'registered' check (status in ('registered','cancelled','attended')),
  created_at timestamptz not null default now(),
  primary key (event_id, user_id)
);

create table public.clubs (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  description text,
  status text not null default 'active' check (status in ('active','inactive','archived')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.club_members (
  club_id uuid not null references public.clubs(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','active','rejected','left')),
  member_role text not null default 'member' check (member_role in ('member','moderator','president')),
  created_at timestamptz not null default now(),
  primary key (club_id, user_id)
);

create table public.forum_categories (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  description text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table public.forum_posts (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.forum_categories(id) on delete set null,
  author_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  status text not null default 'published' check (status in ('published','hidden','deleted')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.forum_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.forum_posts(id) on delete cascade,
  parent_id uuid references public.forum_comments(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  status text not null default 'published' check (status in ('published','hidden','deleted')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.forum_reactions (
  post_id uuid references public.forum_posts(id) on delete cascade,
  comment_id uuid references public.forum_comments(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  reaction text not null default 'like',
  created_at timestamptz not null default now(),
  check ((post_id is not null) <> (comment_id is not null)),
  unique (post_id, comment_id, user_id, reaction)
);

create table public.forum_reports (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references public.forum_posts(id) on delete cascade,
  comment_id uuid references public.forum_comments(id) on delete cascade,
  reported_by uuid not null references public.profiles(id) on delete cascade,
  reason text not null,
  status text not null default 'pending' check (status in ('pending','dismissed','actioned')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  check ((post_id is not null) <> (comment_id is not null))
);

create table public.support_tickets (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references public.profiles(id) on delete cascade,
  category text not null,
  priority text not null default 'normal' check (priority in ('low','normal','high','urgent')),
  subject text not null,
  description text not null,
  status text not null default 'open' check (status in ('open','pending','resolved','closed')),
  assigned_to uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.support_ticket_messages (
  id uuid primary key default gen_random_uuid(),
  ticket_id uuid not null references public.support_tickets(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create table public.scholarships (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  eligibility text,
  deadline timestamptz,
  status text not null default 'draft' check (status in ('draft','published','closed','archived')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.scholarship_applications (
  id uuid primary key default gen_random_uuid(),
  scholarship_id uuid not null references public.scholarships(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  statement text,
  status text not null default 'submitted' check (status in ('draft','submitted','reviewing','approved','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (scholarship_id, student_id)
);

create table public.tuition_invoices (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  semester_id uuid references public.semesters(id),
  invoice_no text unique not null,
  total_amount numeric(12,2) not null check (total_amount >= 0),
  waiver_amount numeric(12,2) not null default 0 check (waiver_amount >= 0),
  previous_balance numeric(12,2) not null default 0 check (previous_balance >= 0),
  due_at timestamptz,
  status text not null default 'unpaid' check (status in ('unpaid','partial','paid','overdue','cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references public.tuition_invoices(id) on delete cascade,
  amount numeric(12,2) not null check (amount > 0),
  method text not null,
  transaction_ref text unique,
  status text not null default 'pending' check (status in ('pending','paid','failed','refunded')),
  paid_at timestamptz,
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.lost_found_items (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.profiles(id) on delete cascade,
  item_type text not null check (item_type in ('lost','found')),
  title text not null,
  description text,
  location text,
  happened_at timestamptz,
  contact_method text,
  photo_path text,
  status text not null default 'open' check (status in ('open','claimed','resolved','hidden')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.lost_found_claims (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.lost_found_items(id) on delete cascade,
  claimant_id uuid not null references public.profiles(id) on delete cascade,
  message text,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.academic_calendar_entries (
  id uuid primary key default gen_random_uuid(),
  semester_id uuid references public.semesters(id) on delete set null,
  title text not null,
  description text,
  starts_at timestamptz not null,
  ends_at timestamptz,
  entry_type text not null default 'deadline' check (entry_type in ('semester','registration','exam','holiday','deadline','event')),
  status text not null default 'draft' check (status in ('draft','published','archived')),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_at is null or ends_at >= starts_at)
);

create table public.approval_requests (
  id uuid primary key default gen_random_uuid(),
  entity_type text not null,
  entity_id uuid,
  requested_by uuid references public.profiles(id),
  reviewed_by uuid references public.profiles(id),
  status text not null default 'pending' check (status in ('pending','approved','rejected','changes_requested')),
  reason text,
  reviewer_comment text,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.system_activity_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id),
  action text not null,
  entity_type text,
  entity_id uuid,
  metadata jsonb not null default '{}',
  created_at timestamptz not null default now()
);

create table public.user_settings (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  theme text not null default 'system' check (theme in ('system','light','dark')),
  notification_preferences jsonb not null default '{}',
  updated_at timestamptz not null default now()
);

create index idx_user_roles_user on public.user_roles(user_id);
create index idx_students_profile on public.students(profile_id);
create index idx_teachers_profile on public.teachers(profile_id);
create index idx_course_enrollments_student on public.course_enrollments(student_id);
create index idx_course_enrollments_section on public.course_enrollments(section_id);
create index idx_teacher_course_assignments_teacher on public.teacher_course_assignments(teacher_id);
create index idx_class_schedules_section_day on public.class_schedules(section_id, day_of_week);
create index idx_attendance_records_student on public.attendance_records(student_id);
create index idx_assignments_section_status on public.assignments(section_id, status);
create index idx_assignment_submissions_student on public.assignment_submissions(student_id);
create index idx_quizzes_section_status on public.quizzes(section_id, status);
create index idx_quiz_attempts_student on public.quiz_attempts(student_id);
create index idx_forum_posts_created on public.forum_posts(created_at desc);
create index idx_forum_comments_post on public.forum_comments(post_id);
create index idx_forum_reports_status on public.forum_reports(status);
create index idx_notifications_user_read on public.notifications(user_id, read_at);
create index idx_support_tickets_requester on public.support_tickets(requester_id);
create index idx_system_activity_created on public.system_activity_logs(created_at desc);

create trigger set_profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger set_faculties_updated_at before update on public.faculties for each row execute function public.set_updated_at();
create trigger set_departments_updated_at before update on public.departments for each row execute function public.set_updated_at();
create trigger set_programs_updated_at before update on public.programs for each row execute function public.set_updated_at();
create trigger set_semesters_updated_at before update on public.semesters for each row execute function public.set_updated_at();
create trigger set_students_updated_at before update on public.students for each row execute function public.set_updated_at();
create trigger set_teachers_updated_at before update on public.teachers for each row execute function public.set_updated_at();
create trigger set_courses_updated_at before update on public.courses for each row execute function public.set_updated_at();
create trigger set_course_sections_updated_at before update on public.course_sections for each row execute function public.set_updated_at();
create trigger set_class_schedules_updated_at before update on public.class_schedules for each row execute function public.set_updated_at();
create trigger set_attendance_sessions_updated_at before update on public.attendance_sessions for each row execute function public.set_updated_at();
create trigger set_attendance_records_updated_at before update on public.attendance_records for each row execute function public.set_updated_at();
create trigger set_assignments_updated_at before update on public.assignments for each row execute function public.set_updated_at();
create trigger set_assignment_submissions_updated_at before update on public.assignment_submissions for each row execute function public.set_updated_at();
create trigger set_quizzes_updated_at before update on public.quizzes for each row execute function public.set_updated_at();
create trigger set_results_updated_at before update on public.results for each row execute function public.set_updated_at();
create trigger set_notices_updated_at before update on public.notices for each row execute function public.set_updated_at();
create trigger set_events_updated_at before update on public.events for each row execute function public.set_updated_at();
create trigger set_clubs_updated_at before update on public.clubs for each row execute function public.set_updated_at();
create trigger set_forum_posts_updated_at before update on public.forum_posts for each row execute function public.set_updated_at();
create trigger set_forum_comments_updated_at before update on public.forum_comments for each row execute function public.set_updated_at();
create trigger set_support_tickets_updated_at before update on public.support_tickets for each row execute function public.set_updated_at();
create trigger set_scholarships_updated_at before update on public.scholarships for each row execute function public.set_updated_at();
create trigger set_scholarship_applications_updated_at before update on public.scholarship_applications for each row execute function public.set_updated_at();
create trigger set_tuition_invoices_updated_at before update on public.tuition_invoices for each row execute function public.set_updated_at();
create trigger set_lost_found_items_updated_at before update on public.lost_found_items for each row execute function public.set_updated_at();
create trigger set_lost_found_claims_updated_at before update on public.lost_found_claims for each row execute function public.set_updated_at();
create trigger set_calendar_entries_updated_at before update on public.academic_calendar_entries for each row execute function public.set_updated_at();
create trigger set_approval_requests_updated_at before update on public.approval_requests for each row execute function public.set_updated_at();
create trigger set_user_settings_updated_at before update on public.user_settings for each row execute function public.set_updated_at();

create or replace function public.has_role(role_code text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.code = role_code
  );
$$;

create or replace function public.current_student_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.students where profile_id = auth.uid();
$$;

create or replace function public.current_teacher_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.teachers where profile_id = auth.uid();
$$;

create or replace function public.teacher_owns_section(section uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.teacher_course_assignments tca
    join public.teachers t on t.id = tca.teacher_id
    where t.profile_id = auth.uid()
      and tca.section_id = section
  );
$$;

create or replace function public.student_enrolled_in_section(section uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.course_enrollments ce
    join public.students s on s.id = ce.student_id
    where s.profile_id = auth.uid()
      and ce.section_id = section
      and ce.status = 'enrolled'
  );
$$;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'profiles','roles','user_roles','faculties','departments','programs','semesters',
    'students','teachers','staff','courses','course_sections','teacher_course_assignments',
    'course_enrollments','rooms','class_schedules','attendance_sessions','attendance_records',
    'assignments','assignment_attachments','assignment_submissions','assignment_submission_files',
    'assignment_grades','quizzes','quiz_questions','quiz_options','quiz_attempts','quiz_answers',
    'results','result_items','notices','notifications','events','event_registrations','clubs',
    'club_members','forum_categories','forum_posts','forum_comments','forum_reactions',
    'forum_reports','support_tickets','support_ticket_messages','scholarships',
    'scholarship_applications','tuition_invoices','payments','lost_found_items',
    'lost_found_claims','academic_calendar_entries','approval_requests','system_activity_logs',
    'user_settings'
  ]
  loop
    execute format('alter table public.%I enable row level security', table_name);
  end loop;
end $$;

insert into public.roles (code, name) values
  ('student', 'Student'),
  ('teacher', 'Teacher'),
  ('faculty', 'Faculty'),
  ('admin', 'Admin')
on conflict (code) do nothing;

create policy "profiles_select_own_or_admin" on public.profiles
  for select using (id = auth.uid() or public.has_role('admin') or public.has_role('faculty'));
create policy "profiles_update_own_limited" on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());
create policy "profiles_insert_self" on public.profiles
  for insert with check (id = auth.uid());

create policy "roles_read_authenticated" on public.roles
  for select to authenticated using (true);
create policy "user_roles_read_own_or_admin" on public.user_roles
  for select using (user_id = auth.uid() or public.has_role('admin'));
create policy "user_roles_admin_write" on public.user_roles
  for all using (public.has_role('admin')) with check (public.has_role('admin'));

create policy "reference_data_read_authenticated" on public.faculties
  for select to authenticated using (true);
create policy "departments_read_authenticated" on public.departments
  for select to authenticated using (true);
create policy "programs_read_authenticated" on public.programs
  for select to authenticated using (true);
create policy "semesters_read_authenticated" on public.semesters
  for select to authenticated using (true);
create policy "courses_read_authenticated" on public.courses
  for select to authenticated using (true);
create policy "sections_read_authenticated" on public.course_sections
  for select to authenticated using (true);
create policy "rooms_read_authenticated" on public.rooms
  for select to authenticated using (true);

create policy "faculty_admin_manage_reference_faculties" on public.faculties
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "faculty_admin_manage_departments" on public.departments
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "faculty_admin_manage_programs" on public.programs
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "faculty_admin_manage_semesters" on public.semesters
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "faculty_admin_manage_courses" on public.courses
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "faculty_admin_manage_sections" on public.course_sections
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));

create policy "students_select_scope" on public.students
  for select using (profile_id = auth.uid() or public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));
create policy "students_faculty_admin_write" on public.students
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "teachers_select_scope" on public.teachers
  for select using (profile_id = auth.uid() or public.has_role('student') or public.has_role('faculty') or public.has_role('admin'));
create policy "teachers_faculty_admin_write" on public.teachers
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "staff_admin_read_write" on public.staff
  for all using (public.has_role('admin')) with check (public.has_role('admin'));

create policy "enrollments_student_teacher_staff_read" on public.course_enrollments
  for select using (
    student_id = public.current_student_id()
    or public.teacher_owns_section(section_id)
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "enrollments_faculty_admin_write" on public.course_enrollments
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));

create policy "teacher_assignments_read_scope" on public.teacher_course_assignments
  for select using (
    teacher_id = public.current_teacher_id()
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "teacher_assignments_faculty_admin_write" on public.teacher_course_assignments
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));

create policy "schedules_read_enrolled_or_assigned" on public.class_schedules
  for select using (
    public.student_enrolled_in_section(section_id)
    or public.teacher_owns_section(section_id)
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "schedules_faculty_admin_write" on public.class_schedules
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));

create policy "attendance_sessions_read_scope" on public.attendance_sessions
  for select using (
    public.student_enrolled_in_section(section_id)
    or public.teacher_owns_section(section_id)
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "attendance_sessions_teacher_write" on public.attendance_sessions
  for all using (public.teacher_owns_section(section_id) or public.has_role('faculty') or public.has_role('admin'))
  with check (public.teacher_owns_section(section_id) or public.has_role('faculty') or public.has_role('admin'));
create policy "attendance_records_read_scope" on public.attendance_records
  for select using (
    student_id = public.current_student_id()
    or exists (
      select 1 from public.attendance_sessions s
      where s.id = attendance_records.session_id
        and public.teacher_owns_section(s.section_id)
    )
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "attendance_records_teacher_write" on public.attendance_records
  for all using (
    exists (
      select 1 from public.attendance_sessions s
      where s.id = attendance_records.session_id
        and (public.teacher_owns_section(s.section_id) or public.has_role('faculty') or public.has_role('admin'))
    )
  ) with check (
    exists (
      select 1 from public.attendance_sessions s
      where s.id = attendance_records.session_id
        and (public.teacher_owns_section(s.section_id) or public.has_role('faculty') or public.has_role('admin'))
    )
  );

create policy "assignments_read_scope" on public.assignments
  for select using (
    public.student_enrolled_in_section(section_id)
    or public.teacher_owns_section(section_id)
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "assignments_teacher_write" on public.assignments
  for all using (public.teacher_owns_section(section_id) or public.has_role('faculty') or public.has_role('admin'))
  with check (public.teacher_owns_section(section_id) or public.has_role('faculty') or public.has_role('admin'));
create policy "assignment_attachments_read_scope" on public.assignment_attachments
  for select using (
    exists (
      select 1 from public.assignments a
      where a.id = assignment_attachments.assignment_id
        and (
          public.student_enrolled_in_section(a.section_id)
          or public.teacher_owns_section(a.section_id)
          or public.has_role('faculty')
          or public.has_role('admin')
        )
    )
  );
create policy "assignment_attachments_teacher_write" on public.assignment_attachments
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));
create policy "submissions_read_scope" on public.assignment_submissions
  for select using (
    student_id = public.current_student_id()
    or exists (
      select 1 from public.assignments a
      where a.id = assignment_submissions.assignment_id
        and public.teacher_owns_section(a.section_id)
    )
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "submissions_student_insert_update" on public.assignment_submissions
  for all using (student_id = public.current_student_id())
  with check (
    student_id = public.current_student_id()
    and exists (
      select 1 from public.assignments a
      where a.id = assignment_submissions.assignment_id
        and public.student_enrolled_in_section(a.section_id)
    )
  );
create policy "submission_files_read_scope" on public.assignment_submission_files
  for select using (
    exists (
      select 1 from public.assignment_submissions s
      where s.id = assignment_submission_files.submission_id
        and (
          s.student_id = public.current_student_id()
          or public.has_role('faculty')
          or public.has_role('admin')
          or exists (
            select 1 from public.assignments a
            where a.id = s.assignment_id
              and public.teacher_owns_section(a.section_id)
          )
        )
    )
  );
create policy "submission_files_student_write" on public.assignment_submission_files
  for all using (true) with check (
    exists (
      select 1 from public.assignment_submissions s
      where s.id = assignment_submission_files.submission_id
        and s.student_id = public.current_student_id()
    )
  );
create policy "grades_read_scope" on public.assignment_grades
  for select using (
    exists (
      select 1 from public.assignment_submissions s
      where s.id = assignment_grades.submission_id
        and (
          s.student_id = public.current_student_id()
          or public.has_role('faculty')
          or public.has_role('admin')
          or exists (
            select 1 from public.assignments a
            where a.id = s.assignment_id
              and public.teacher_owns_section(a.section_id)
          )
        )
    )
  );
create policy "grades_teacher_write" on public.assignment_grades
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));

create policy "quizzes_read_scope" on public.quizzes
  for select using (
    public.student_enrolled_in_section(section_id)
    or public.teacher_owns_section(section_id)
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "quizzes_teacher_write" on public.quizzes
  for all using (public.teacher_owns_section(section_id) or public.has_role('faculty') or public.has_role('admin'))
  with check (public.teacher_owns_section(section_id) or public.has_role('faculty') or public.has_role('admin'));
create policy "quiz_questions_read_scope" on public.quiz_questions
  for select using (
    exists (
      select 1 from public.quizzes q
      where q.id = quiz_questions.quiz_id
        and (
          public.student_enrolled_in_section(q.section_id)
          or public.teacher_owns_section(q.section_id)
          or public.has_role('faculty')
          or public.has_role('admin')
        )
    )
  );
create policy "quiz_questions_teacher_write" on public.quiz_questions
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));
create policy "quiz_options_read_scope" on public.quiz_options
  for select using (
    exists (
      select 1 from public.quiz_questions qq
      join public.quizzes q on q.id = qq.quiz_id
      where qq.id = quiz_options.question_id
        and (
          public.student_enrolled_in_section(q.section_id)
          or public.teacher_owns_section(q.section_id)
          or public.has_role('faculty')
          or public.has_role('admin')
        )
    )
  );
create policy "quiz_options_teacher_write" on public.quiz_options
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));
create policy "quiz_attempts_read_scope" on public.quiz_attempts
  for select using (
    student_id = public.current_student_id()
    or exists (
      select 1 from public.quizzes q
      where q.id = quiz_attempts.quiz_id
        and public.teacher_owns_section(q.section_id)
    )
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "quiz_attempts_student_write" on public.quiz_attempts
  for all using (student_id = public.current_student_id())
  with check (student_id = public.current_student_id());
create policy "quiz_answers_attempt_scope" on public.quiz_answers
  for all using (
    exists (
      select 1 from public.quiz_attempts qa
      where qa.id = quiz_answers.attempt_id
        and qa.student_id = public.current_student_id()
    )
    or public.has_role('teacher')
    or public.has_role('faculty')
    or public.has_role('admin')
  ) with check (
    exists (
      select 1 from public.quiz_attempts qa
      where qa.id = quiz_answers.attempt_id
        and qa.student_id = public.current_student_id()
    )
    or public.has_role('teacher')
    or public.has_role('faculty')
    or public.has_role('admin')
  );

create policy "results_read_released_scope" on public.results
  for select using (
    (student_id = public.current_student_id() and status = 'published')
    or public.has_role('teacher')
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "results_staff_write" on public.results
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));
create policy "result_items_read_released_scope" on public.result_items
  for select using (
    exists (
      select 1 from public.results r
      where r.id = result_items.result_id
        and (
          (r.student_id = public.current_student_id() and r.status = 'published')
          or public.has_role('teacher')
          or public.has_role('faculty')
          or public.has_role('admin')
        )
    )
  );
create policy "result_items_staff_write" on public.result_items
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));

create policy "notices_read_published" on public.notices
  for select using (
    status = 'published'
    or created_by = auth.uid()
    or public.has_role('faculty')
    or public.has_role('admin')
  );
create policy "notices_authorized_write" on public.notices
  for all using (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('teacher') or public.has_role('faculty') or public.has_role('admin'));
create policy "notifications_own" on public.notifications
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "events_read_approved" on public.events
  for select using (status in ('approved','published') or created_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "events_create_authenticated" on public.events
  for insert with check (created_by = auth.uid());
create policy "events_staff_update" on public.events
  for update using (created_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (created_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "event_registrations_own" on public.event_registrations
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "clubs_read_authenticated" on public.clubs
  for select to authenticated using (status <> 'archived' or public.has_role('admin'));
create policy "clubs_staff_write" on public.clubs
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "club_members_own_or_staff" on public.club_members
  for all using (user_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (user_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'));

create policy "forum_categories_read" on public.forum_categories
  for select to authenticated using (true);
create policy "forum_categories_staff_write" on public.forum_categories
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "forum_posts_read_published" on public.forum_posts
  for select using (status = 'published' or author_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "forum_posts_author_write" on public.forum_posts
  for all using (author_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (author_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "forum_comments_read_published" on public.forum_comments
  for select using (status = 'published' or author_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "forum_comments_author_write" on public.forum_comments
  for all using (author_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (author_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "forum_reactions_own" on public.forum_reactions
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "forum_reports_create_read_own_or_staff" on public.forum_reports
  for select using (reported_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "forum_reports_insert_own" on public.forum_reports
  for insert with check (reported_by = auth.uid());
create policy "forum_reports_staff_update" on public.forum_reports
  for update using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));

create policy "support_tickets_own_or_staff" on public.support_tickets
  for select using (requester_id = auth.uid() or assigned_to = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "support_tickets_create_own" on public.support_tickets
  for insert with check (requester_id = auth.uid());
create policy "support_tickets_update_scope" on public.support_tickets
  for update using (requester_id = auth.uid() or assigned_to = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (requester_id = auth.uid() or assigned_to = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "support_messages_scope" on public.support_ticket_messages
  for all using (
    sender_id = auth.uid()
    or exists (
      select 1 from public.support_tickets t
      where t.id = support_ticket_messages.ticket_id
        and (t.requester_id = auth.uid() or t.assigned_to = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
    )
  ) with check (
    sender_id = auth.uid()
    and exists (
      select 1 from public.support_tickets t
      where t.id = support_ticket_messages.ticket_id
        and (t.requester_id = auth.uid() or t.assigned_to = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
    )
  );

create policy "scholarships_read_published" on public.scholarships
  for select using (status = 'published' or public.has_role('faculty') or public.has_role('admin'));
create policy "scholarships_staff_write" on public.scholarships
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "scholarship_apps_scope" on public.scholarship_applications
  for all using (student_id = public.current_student_id() or public.has_role('faculty') or public.has_role('admin'))
  with check (student_id = public.current_student_id() or public.has_role('faculty') or public.has_role('admin'));

create policy "invoices_student_or_staff" on public.tuition_invoices
  for select using (student_id = public.current_student_id() or public.has_role('faculty') or public.has_role('admin'));
create policy "invoices_staff_write" on public.tuition_invoices
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "payments_student_or_staff" on public.payments
  for select using (
    exists (
      select 1 from public.tuition_invoices i
      where i.id = payments.invoice_id
        and (i.student_id = public.current_student_id() or public.has_role('faculty') or public.has_role('admin'))
    )
  );
create policy "payments_staff_write" on public.payments
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));

create policy "lost_found_read_visible" on public.lost_found_items
  for select using (status <> 'hidden' or created_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "lost_found_create_own" on public.lost_found_items
  for insert with check (created_by = auth.uid());
create policy "lost_found_update_scope" on public.lost_found_items
  for update using (created_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (created_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "lost_found_claims_scope" on public.lost_found_claims
  for all using (claimant_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'))
  with check (claimant_id = auth.uid() or public.has_role('faculty') or public.has_role('admin'));

create policy "calendar_read_published" on public.academic_calendar_entries
  for select using (status = 'published' or public.has_role('faculty') or public.has_role('admin'));
create policy "calendar_staff_write" on public.academic_calendar_entries
  for all using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "approval_requests_scope" on public.approval_requests
  for select using (requested_by = auth.uid() or public.has_role('faculty') or public.has_role('admin'));
create policy "approval_requests_create_own" on public.approval_requests
  for insert with check (requested_by = auth.uid());
create policy "approval_requests_staff_update" on public.approval_requests
  for update using (public.has_role('faculty') or public.has_role('admin'))
  with check (public.has_role('faculty') or public.has_role('admin'));
create policy "system_activity_admin_read" on public.system_activity_logs
  for select using (public.has_role('admin'));
create policy "system_activity_authenticated_insert" on public.system_activity_logs
  for insert with check (actor_id = auth.uid() or actor_id is null);
create policy "user_settings_own" on public.user_settings
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create or replace view public.forum_stats
with (security_invoker = true) as
select
  (select count(*)::int from public.forum_posts where status = 'published') as post_count,
  (select count(*)::int from public.forum_comments where status = 'published') as comment_count,
  (select count(*)::int from public.forum_reports where status = 'pending') as pending_report_count;

create or replace view public.dashboard_counts
with (security_invoker = true) as
select
  (select count(*)::int from public.students where status = 'active') as active_students,
  (select count(*)::int from public.teachers where status = 'active') as active_teachers,
  (select count(*)::int from public.departments where status = 'active') as active_departments,
  (select count(*)::int from public.support_tickets where status in ('open','pending')) as open_support_tickets,
  (select count(*)::int from public.approval_requests where status = 'pending') as pending_approvals,
  (select count(*)::int from public.forum_reports where status = 'pending') as pending_moderation_reports,
  (select count(*)::int from public.events where status in ('approved','published')) as published_events;
