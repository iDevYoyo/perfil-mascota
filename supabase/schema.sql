-- =====================================================================
-- Tapreview · Perfiles de mascota
-- Pega TODO este archivo en Supabase → SQL Editor → New query → Run.
-- Se puede correr más de una vez sin romper nada.
-- =====================================================================

-- 1) Tabla de mascotas ------------------------------------------------
create table if not exists public.mascotas (
    id                   text primary key
                         check (id ~ '^[a-z0-9-]{3,40}$'),   -- lo que va en ?id=...
    owner_email          text not null,                        -- correo del dueño (para que edite)
    nombre               text not null,
    mensaje              text,
    dueno                text,
    telefono             text,
    whatsapp             text,
    ciudad               text,
    nota                 text,
    especie              text,
    raza                 text,
    color                text,
    edad                 text,
    alergias             text,
    medicamentos         text,
    veterinaria          text,
    veterinaria_telefono text,
    perdido              boolean not null default false,
    recompensa           text,
    foto                 text,
    creado               timestamptz not null default now(),
    actualizado          timestamptz not null default now()
);

-- Fecha de última edición automática
create or replace function public.tocar_actualizado()
returns trigger language plpgsql as $$
begin
    new.actualizado := now();
    return new;
end $$;

drop trigger if exists mascotas_actualizado on public.mascotas;
create trigger mascotas_actualizado
    before update on public.mascotas
    for each row execute function public.tocar_actualizado();

-- 2) Seguridad --------------------------------------------------------
-- Nadie puede listar la tabla desde la página. Solo:
--   * el público ve UNA mascota a la vez si conoce su id (función de abajo)
--   * el dueño ve y edita SUS mascotas después de entrar con su correo
alter table public.mascotas enable row level security;

revoke all on public.mascotas from anon, authenticated;
grant select on public.mascotas to authenticated;
-- El dueño puede editar estos campos, pero NO el id, el correo dueño ni la foto
grant update (
    nombre, mensaje, dueno, telefono, whatsapp, ciudad, nota,
    especie, raza, color, edad,
    alergias, medicamentos, veterinaria, veterinaria_telefono,
    perdido, recompensa
) on public.mascotas to authenticated;

drop policy if exists "dueno ve sus mascotas" on public.mascotas;
create policy "dueno ve sus mascotas" on public.mascotas
    for select to authenticated
    using (lower(owner_email) = lower(auth.jwt() ->> 'email'));

drop policy if exists "dueno edita sus mascotas" on public.mascotas;
create policy "dueno edita sus mascotas" on public.mascotas
    for update to authenticated
    using (lower(owner_email) = lower(auth.jwt() ->> 'email'))
    with check (lower(owner_email) = lower(auth.jwt() ->> 'email'));

-- 3) Perfil público: devuelve UNA mascota por id, sin el correo del dueño
create or replace function public.perfil_publico(p_id text)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
    select to_jsonb(m) - 'owner_email' - 'creado'
    from public.mascotas m
    where m.id = lower(trim(p_id));
$$;

revoke all on function public.perfil_publico(text) from public;
grant execute on function public.perfil_publico(text) to anon, authenticated;

-- 4) Mascotas actuales (cambia el correo por el del dueño real) --------
insert into public.mascotas (id, owner_email, nombre, mensaje, dueno, telefono, ciudad, nota)
values
    ('zuky',  'CAMBIAR@correo.cl', 'Zuky 🐾',  'Por favor, extraño a mi familia.',     'matoldo', '+56900000000', 'Curicó', 'Soy amigable, me gustan los pajaros.'),
    ('dora',  'CAMBIAR@correo.cl', 'Dora 🐈',  'Me perdí, contacta a mi familia.',     'Pedro',   '+56900000000', 'Curicó', 'No me gusta que me toquen la cola.'),
    ('cuco2', 'CAMBIAR@correo.cl', 'Cuco2 🐾', 'Por favor, ayúdame a volver a casa.',  'Pedro',   '+56900000000', 'Curicó', 'Soy amigable pero estoy asustado.')
on conflict (id) do nothing;

insert into public.mascotas (id, owner_email, nombre, especie, raza, color, edad, mensaje, dueno, telefono, ciudad, nota,
                             perdido, recompensa, alergias, medicamentos, veterinaria, veterinaria_telefono)
values ('demo', 'CAMBIAR@correo.cl', 'Demo 🐶', 'Perro', 'Mestizo', 'Café con blanco', '3 años',
        'Me perdí, ayúdame a volver a casa.', 'Tapreview', '+56900000000', 'Curicó',
        'Soy amigable, pero me asustan los ruidos fuertes.', true, '$30.000',
        'Pollo', 'Ninguno', 'Clínica Veterinaria Ejemplo', '+56900000000')
on conflict (id) do nothing;
