-- Optional development seed.
-- This file intentionally creates relational rows, not fake counters in Flutter.
-- For auth users, create users in Supabase Auth first, then replace these UUIDs
-- with their auth.users ids before inserting profiles/user_roles.

insert into public.faculties (id, name, code, status)
values
  ('00000000-0000-4000-8000-000000000001', 'Faculty of Science and Engineering', 'FSE', 'active')
on conflict (code) do nothing;

insert into public.departments (id, faculty_id, name, code, contact_email, status)
values
  (
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000001',
    'Computer Science and Engineering',
    'CSE',
    'cse@eub.edu',
    'active'
  )
on conflict (code) do nothing;

insert into public.programs (id, department_id, name, code, degree_level, total_semesters)
values
  (
    '00000000-0000-4000-8000-000000000021',
    '00000000-0000-4000-8000-000000000011',
    'BSc in Computer Science and Engineering',
    'BSC-CSE',
    'undergraduate',
    8
  )
on conflict (department_id, code) do nothing;

insert into public.semesters (id, name, starts_at, ends_at, status)
values
  (
    '00000000-0000-4000-8000-000000000031',
    'Summer 2026',
    '2026-05-01',
    '2026-08-31',
    'active'
  )
on conflict (name) do nothing;

insert into public.courses (id, department_id, code, title, credits, course_type)
values
  (
    '00000000-0000-4000-8000-000000000041',
    '00000000-0000-4000-8000-000000000011',
    'CSE 410',
    'Artificial Intelligence',
    3,
    'theory'
  ),
  (
    '00000000-0000-4000-8000-000000000042',
    '00000000-0000-4000-8000-000000000011',
    'CSE 420',
    'Software Engineering',
    3,
    'theory'
  ),
  (
    '00000000-0000-4000-8000-000000000043',
    '00000000-0000-4000-8000-000000000011',
    'MAT 301',
    'Numerical Methods',
    3,
    'theory'
  )
on conflict (code) do nothing;

insert into public.course_sections (id, course_id, semester_id, section_code, capacity, status)
values
  (
    '00000000-0000-4000-8000-000000000051',
    '00000000-0000-4000-8000-000000000041',
    '00000000-0000-4000-8000-000000000031',
    'A',
    45,
    'published'
  ),
  (
    '00000000-0000-4000-8000-000000000052',
    '00000000-0000-4000-8000-000000000042',
    '00000000-0000-4000-8000-000000000031',
    'A',
    45,
    'published'
  )
on conflict (course_id, semester_id, section_code) do nothing;

insert into public.rooms (id, building, room_no, capacity, room_type)
values
  ('00000000-0000-4000-8000-000000000061', 'CSE Building', '604', 50, 'classroom'),
  ('00000000-0000-4000-8000-000000000062', 'CSE Building', 'Lab 3', 35, 'lab')
on conflict (building, room_no) do nothing;

insert into public.class_schedules (
  section_id,
  room_id,
  day_of_week,
  starts_at,
  ends_at,
  class_type,
  status
)
values
  (
    '00000000-0000-4000-8000-000000000051',
    '00000000-0000-4000-8000-000000000061',
    1,
    '09:00',
    '10:20',
    'theory',
    'published'
  ),
  (
    '00000000-0000-4000-8000-000000000052',
    '00000000-0000-4000-8000-000000000062',
    3,
    '11:00',
    '12:20',
    'lab',
    'published'
  );

insert into public.assignments (
  section_id,
  title,
  instructions,
  total_marks,
  opens_at,
  due_at,
  status
)
values
  (
    '00000000-0000-4000-8000-000000000051',
    'Search Algorithms Lab Report',
    'Compare BFS, DFS, UCS, and A* using a campus navigation problem.',
    20,
    now(),
    now() + interval '7 days',
    'published'
  );

insert into public.quizzes (
  section_id,
  title,
  instructions,
  duration_minutes,
  total_marks,
  opens_at,
  closes_at,
  attempt_limit,
  show_result_immediately,
  status
)
values
  (
    '00000000-0000-4000-8000-000000000051',
    'Informed Search Quiz',
    'Answer all questions before the timer ends.',
    20,
    20,
    now(),
    now() + interval '5 days',
    1,
    true,
    'published'
  );

insert into public.forum_categories (name, description, sort_order)
values
  ('Academic Help', 'Course, routine, result, and study discussions', 1),
  ('Campus Life', 'Clubs, events, lost-found, and campus questions', 2)
on conflict (name) do nothing;

insert into public.notices (title, body, audience, published_at, status)
values
  (
    'Welcome to EUB Connect',
    'This notice is loaded from the database seed, not Flutter source code.',
    'everyone',
    now(),
    'published'
  );
