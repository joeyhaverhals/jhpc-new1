-- Create storage buckets
insert into storage.buckets (id, name, public) values 
  ('avatars', 'avatars', true),
  ('posts', 'posts', true),
  ('services', 'services', true),
  ('about', 'about', true);

-- Set up storage policies
create policy "Avatar images are publicly accessible"
  on storage.objects for select
  using ( bucket_id = 'avatars' );

create policy "Post images are publicly accessible"
  on storage.objects for select
  using ( bucket_id = 'posts' );

create policy "Service images are publicly accessible"
  on storage.objects for select
  using ( bucket_id = 'services' );

create policy "About images are publicly accessible"
  on storage.objects for select
  using ( bucket_id = 'about' );

-- Authenticated users can upload avatars
create policy "Users can upload their own avatar"
  on storage.objects for insert
  with check ( bucket_id = 'avatars' AND auth.uid() = owner );

-- Admins and editors can upload content images
create policy "Admins and editors can upload content images"
  on storage.objects for insert
  with check (
    bucket_id in ('posts', 'services', 'about') AND
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role in ('admin', 'editor')
    )
  );
