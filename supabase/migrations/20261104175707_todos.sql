create table if not exists public.todos (
  id uuid primary key default gen_random_uuid(),
  text text not null check (char_length(text) between 1 and 500),
  done boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.todos enable row level security;

-- Sayfa giriş yapmadan (anon anahtarla) çalıştığı için anon rolüne tam erişim verilir.
create policy "anon read"   on public.todos for select to anon using (true);
create policy "anon insert" on public.todos for insert to anon with check (true);
create policy "anon update" on public.todos for update to anon using (true) with check (true);
create policy "anon delete" on public.todos for delete to anon using (true);

grant select, insert, update, delete on public.todos to anon;
