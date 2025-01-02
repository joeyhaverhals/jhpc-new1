-- Enable necessary extensions
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- Create custom types
create type user_role as enum ('admin', 'editor', 'vip', 'user');
create type content_status as enum ('draft', 'scheduled', 'published');
create type testimonial_status as enum ('pending', 'approved', 'rejected');
create type chat_status as enum ('active', 'completed', 'error');
create type billing_frequency as enum ('per_4_weeks', 'one_time');

-- Create users table extensions
create table public.user_profiles (
  id uuid references auth.users on delete cascade,
  first_name text,
  last_name text,
  role user_role default 'user'::user_role,
  status text default 'active',
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  primary key (id)
);

-- Create posts table
create table public.posts (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  slug text not null unique,
  content text,
  status content_status default 'draft'::content_status,
  author_id uuid references auth.users on delete cascade,
  categories text[] default array[]::text[],
  tags text[] default array[]::text[],
  seo jsonb default '{}'::jsonb,
  featured_image text,
  scheduled_at timestamp with time zone,
  published_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create services table
create table public.services (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  short_description text,
  full_description text,
  price decimal(10,2) not null,
  billing_frequency billing_frequency default 'one_time'::billing_frequency,
  image_url text,
  order_index integer not null default 0,
  is_active boolean default true,
  seo jsonb default '{}'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create FAQs table
create table public.faqs (
  id uuid default uuid_generate_v4() primary key,
  question text not null,
  answer text not null,
  category text not null,
  order_index integer not null default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create testimonials table
create table public.testimonials (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users on delete cascade,
  content text not null,
  rating integer not null check (rating >= 1 and rating <= 5),
  status testimonial_status default 'pending'::testimonial_status,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create about content table
create table public.about_content (
  id uuid default uuid_generate_v4() primary key,
  content text not null,
  images text[] default array[]::text[],
  version integer not null default 1,
  published_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create AI chat configuration table
create table public.ai_chat_config (
  id uuid default uuid_generate_v4() primary key,
  status text default 'active',
  provider text default 'gpt4',
  maintenance_message text,
  allowed_roles user_role[] default array['admin', 'vip']::user_role[],
  allowed_users uuid[] default array[]::uuid[],
  time_restrictions jsonb default '{"enabled": false, "daysOfWeek": [1,2,3,4,5], "startTime": "09:00", "endTime": "17:00"}'::jsonb,
  api_config jsonb default '{}'::jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create chat sessions table
create table public.chat_sessions (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users on delete cascade,
  status chat_status default 'active'::chat_status,
  message_count integer default 0,
  token_usage integer default 0,
  started_at timestamp with time zone default timezone('utc'::text, now()) not null,
  ended_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create chat messages table
create table public.chat_messages (
  id uuid default uuid_generate_v4() primary key,
  session_id uuid references public.chat_sessions on delete cascade,
  role text not null check (role in ('user', 'assistant', 'system')),
  content text not null,
  token_count integer,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create contact messages table
create table public.contact_messages (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  email text not null,
  subject text not null,
  message text not null,
  status text default 'unread',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
