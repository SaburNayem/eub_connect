-- Default public signups to the student role. Admins can later grant teacher,
-- faculty, or admin roles through controlled role-management UI/actions.

create or replace function public.assign_default_student_role()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  student_role_id uuid;
begin
  select id into student_role_id from public.roles where code = 'student';
  if student_role_id is not null then
    insert into public.user_roles (user_id, role_id)
    values (new.id, student_role_id)
    on conflict do nothing;
  end if;
  return new;
end;
$$;

drop trigger if exists assign_default_student_role_on_profile on public.profiles;
create trigger assign_default_student_role_on_profile
after insert on public.profiles
for each row execute function public.assign_default_student_role();
