-- Her görev bir kullanıcıya ait olur; kullanıcı yalnızca kendi görevlerini görür.
alter table public.todos
  add column if not exists user_id uuid references auth.users(id) on delete cascade default auth.uid();

create index if not exists todos_user_id_idx on public.todos(user_id);

-- Giriş yapmamış (anon) erişimi kapat
drop policy if exists "anon read"   on public.todos;
drop policy if exists "anon insert" on public.todos;
drop policy if exists "anon update" on public.todos;
drop policy if exists "anon delete" on public.todos;
revoke all on public.todos from anon;

grant select, insert, update, delete on public.todos to authenticated;

create policy "own read"   on public.todos for select to authenticated using (user_id = auth.uid());
create policy "own insert" on public.todos for insert to authenticated with check (user_id = auth.uid());
create policy "own update" on public.todos for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own delete" on public.todos for delete to authenticated using (user_id = auth.uid());
