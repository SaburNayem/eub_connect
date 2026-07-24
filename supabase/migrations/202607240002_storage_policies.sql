-- Storage bucket and policies for protected academic/user uploads.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'app-files',
  'app-files',
  false,
  10485760,
  array[
    'application/pdf',
    'image/jpeg',
    'image/png',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/zip',
    'text/plain'
  ]
)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

create policy "authenticated_can_upload_own_folder"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'app-files'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "authenticated_can_read_permitted_own_folder"
on storage.objects for select
to authenticated
using (
  bucket_id = 'app-files'
  and (
    (storage.foldername(name))[1] = auth.uid()::text
    or public.has_role('teacher')
    or public.has_role('faculty')
    or public.has_role('admin')
  )
);

create policy "authenticated_can_update_own_folder"
on storage.objects for update
to authenticated
using (
  bucket_id = 'app-files'
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'app-files'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create policy "authenticated_can_delete_own_or_admin"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'app-files'
  and (
    (storage.foldername(name))[1] = auth.uid()::text
    or public.has_role('admin')
  )
);
