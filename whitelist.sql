-- THE HOOD ROVER WHITELIST
-- Run once in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.whitelist_entries (
  id uuid primary key default gen_random_uuid(),
  twitter_username text not null,
  wallet_address text not null,
  follow_task boolean not null default false,
  like_task boolean not null default false,
  repost_comment_task boolean not null default false,
  created_at timestamptz not null default now()
);

create unique index if not exists whitelist_entries_twitter_username_unique
on public.whitelist_entries (lower(twitter_username));

create unique index if not exists whitelist_entries_wallet_address_unique
on public.whitelist_entries (lower(wallet_address));

alter table public.whitelist_entries enable row level security;

drop policy if exists "whitelist_public_insert" on public.whitelist_entries;

create policy "whitelist_public_insert"
on public.whitelist_entries
for insert
to anon, authenticated
with check (
  twitter_username <> ''
  and wallet_address <> ''
);

-- No public SELECT policy is created.
-- This keeps submitted whitelist entries private from the frontend.
