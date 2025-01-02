-- Function to handle user creation
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.user_profiles (id, first_name, last_name, role)
  values (
    new.id,
    new.raw_user_meta_data->>'first_name',
    new.raw_user_meta_data->>'last_name',
    'user'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Drop existing trigger if it exists
drop trigger if exists on_auth_user_created on auth.users;

-- Create new trigger for user creation
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Function to update updated_at column
create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Add updated_at triggers to all relevant tables
drop trigger if exists update_user_profiles_updated_at on public.user_profiles;
create trigger update_user_profiles_updated_at
  before update on public.user_profiles
  for each row execute procedure public.update_updated_at_column();

drop trigger if exists update_posts_updated_at on public.posts;
create trigger update_posts_updated_at
  before update on public.posts
  for each row execute procedure public.update_updated_at_column();

drop trigger if exists update_services_updated_at on public.services;
create trigger update_services_updated_at
  before update on public.services
  for each row execute procedure public.update_updated_at_column();

drop trigger if exists update_faqs_updated_at on public.faqs;
create trigger update_faqs_updated_at
  before update on public.faqs
  for each row execute procedure public.update_updated_at_column();

drop trigger if exists update_testimonials_updated_at on public.testimonials;
create trigger update_testimonials_updated_at
  before update on public.testimonials
  for each row execute procedure public.update_updated_at_column();

drop trigger if exists update_about_content_updated_at on public.about_content;
create trigger update_about_content_updated_at
  before update on public.about_content
  for each row execute procedure public.update_updated_at_column();

drop trigger if exists update_ai_chat_config_updated_at on public.ai_chat_config;
create trigger update_ai_chat_config_updated_at
  before update on public.ai_chat_config
  for each row execute procedure public.update_updated_at_column();
