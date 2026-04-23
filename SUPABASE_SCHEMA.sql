create extension if not exists "pgcrypto";

create table if not exists public.profiles (
    id uuid primary key references auth.users (id) on delete cascade,
    email text not null default '',
    created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.user_settings (
    user_id uuid primary key references auth.users (id) on delete cascade,
    study_time text not null default '07:30',
    words_per_group integer not null default 50,
    minutes_per_group integer not null default 5,
    groups_per_day integer not null default 6,
    updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.study_sessions (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users (id) on delete cascade,
    session_key text not null,
    study_date date not null,
    words integer not null default 0,
    groups integer not null default 0,
    created_at timestamptz not null default timezone('utc', now()),
    updated_at timestamptz not null default timezone('utc', now()),
    unique (user_id, session_key)
);

create index if not exists study_sessions_user_created_at_idx
    on public.study_sessions (user_id, created_at asc);

alter table public.profiles enable row level security;
alter table public.user_settings enable row level security;
alter table public.study_sessions enable row level security;

grant usage on schema public to anon, authenticated;
grant select, insert, update on table public.profiles to authenticated;
grant select, insert, update on table public.user_settings to authenticated;
grant select, insert, update on table public.study_sessions to authenticated;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
    on public.profiles
    for select
    using (auth.uid() = id);

drop policy if exists "profiles_upsert_own" on public.profiles;
create policy "profiles_upsert_own"
    on public.profiles
    for insert
    with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
    on public.profiles
    for update
    using (auth.uid() = id)
    with check (auth.uid() = id);

drop policy if exists "settings_select_own" on public.user_settings;
create policy "settings_select_own"
    on public.user_settings
    for select
    using (auth.uid() = user_id);

drop policy if exists "settings_insert_own" on public.user_settings;
create policy "settings_insert_own"
    on public.user_settings
    for insert
    with check (auth.uid() = user_id);

drop policy if exists "settings_update_own" on public.user_settings;
create policy "settings_update_own"
    on public.user_settings
    for update
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

drop policy if exists "sessions_select_own" on public.study_sessions;
create policy "sessions_select_own"
    on public.study_sessions
    for select
    using (auth.uid() = user_id);

drop policy if exists "sessions_insert_own" on public.study_sessions;
create policy "sessions_insert_own"
    on public.study_sessions
    for insert
    with check (auth.uid() = user_id);

drop policy if exists "sessions_update_own" on public.study_sessions;
create policy "sessions_update_own"
    on public.study_sessions
    for update
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);
