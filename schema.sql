-- Base Board tables. Applied to Supabase project ourplace-scratch on 2026-10-10.
create table if not exists public.board_pieces (
  id text primary key check (length(id) between 4 and 40),
  room text not null check (room ~ '^[a-z0-9-]{3,40}$'),
  t text not null check (t in ('tri','sq')),
  x double precision not null check (abs(x) < 1e6),
  y double precision not null check (abs(y) < 1e6),
  r double precision not null default 0,
  c integer not null default 0 check (c between 0 and 5),
  updated_at timestamptz not null default now()
);
create index if not exists board_pieces_room_idx on public.board_pieces (room);

create table if not exists public.board_notes (
  room text primary key check (room ~ '^[a-z0-9-]{3,40}$'),
  text text not null default '' check (length(text) <= 4000),
  updated_at timestamptz not null default now()
);

alter table public.board_pieces enable row level security;
alter table public.board_notes enable row level security;
create policy board_pieces_open on public.board_pieces for all to anon, authenticated using (true) with check (true);
create policy board_notes_open on public.board_notes for all to anon, authenticated using (true) with check (true);

create or replace function public.board_pieces_cap() returns trigger language plpgsql as $$
begin
  if (select count(*) from public.board_pieces where room = new.room) >= 3000 then
    raise exception 'room is full (3000 pieces)';
  end if;
  new.updated_at := now();
  return new;
end $$;
drop trigger if exists board_pieces_cap_trg on public.board_pieces;
create trigger board_pieces_cap_trg before insert on public.board_pieces for each row execute function public.board_pieces_cap();

alter publication supabase_realtime add table public.board_pieces;
alter publication supabase_realtime add table public.board_notes;
alter table public.board_pieces replica identity full;
