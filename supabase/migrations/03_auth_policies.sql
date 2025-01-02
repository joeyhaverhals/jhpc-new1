-- User profiles policies
create policy "Users can view all profiles"
  on public.user_profiles for select
  using ( true );

create policy "Users can update their own profile"
  on public.user_profiles for update
  using ( auth.uid() = id );

-- Posts policies
create policy "Anyone can view published posts"
  on public.posts for select
  using ( status = 'published' OR auth.uid() = author_id );

create policy "Admins and editors can manage posts"
  on public.posts for all
  using (
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role in ('admin', 'editor')
    )
  );

-- Services policies
create policy "Anyone can view active services"
  on public.services for select
  using ( is_active = true );

create policy "Admins and editors can manage services"
  on public.services for all
  using (
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role in ('admin', 'editor')
    )
  );

-- FAQs policies
create policy "Anyone can view FAQs"
  on public.faqs for select
  using ( true );

create policy "Admins and editors can manage FAQs"
  on public.faqs for all
  using (
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role in ('admin', 'editor')
    )
  );

-- Testimonials policies
create policy "Anyone can view approved testimonials"
  on public.testimonials for select
  using ( status = 'approved' );

create policy "Users can submit testimonials"
  on public.testimonials for insert
  with check ( auth.uid() = user_id );

create policy "Admins can manage testimonials"
  on public.testimonials for all
  using (
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role = 'admin'
    )
  );

-- About content policies
create policy "Anyone can view about content"
  on public.about_content for select
  using ( true );

create policy "Admins and editors can manage about content"
  on public.about_content for all
  using (
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role in ('admin', 'editor')
    )
  );

-- AI chat policies
create policy "Authorized users can access chat"
  on public.chat_sessions for all
  using (
    exists (
      select 1 from public.user_profiles up
      cross join public.ai_chat_config acc
      where up.id = auth.uid()
      and (
        up.role = any(acc.allowed_roles)
        or up.id = any(acc.allowed_users)
      )
    )
  );

-- Contact messages policies
create policy "Anyone can submit contact messages"
  on public.contact_messages for insert
  with check ( true );

create policy "Admins can view contact messages"
  on public.contact_messages for select
  using (
    exists (
      select 1 from public.user_profiles
      where id = auth.uid()
      and role = 'admin'
    )
  );
