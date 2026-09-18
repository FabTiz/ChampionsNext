
  create table "public"."fantacalcio_calciatori" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "nome" text not null,
    "ruolo" text not null,
    "squadra_reale" text not null,
    "valore_iniziale" numeric(10,2),
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_calciatori" enable row level security;


  create table "public"."fantacalcio_commenti_documenti" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "documento_id" uuid not null,
    "autore_id" uuid not null,
    "testo" text not null,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_commenti_documenti" enable row level security;


  create table "public"."fantacalcio_documenti" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "titolo" text not null,
    "descrizione" text,
    "categoria" text not null default 'altro'::text,
    "visibilita" text not null default 'lega'::text,
    "file_path" text not null,
    "autore_id" uuid not null,
    "lega_id" uuid,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_documenti" enable row level security;


  create table "public"."fantacalcio_giornate" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "lega_id" uuid not null,
    "numero" integer not null,
    "stato" text not null default 'bozza'::text,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_giornate" enable row level security;


  create table "public"."fantacalcio_leghe" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "nome" text not null,
    "descrizione" text,
    "stagione" text,
    "creatore_id" uuid not null,
    "data_inizio" date,
    "data_fine" date,
    "max_squadre" integer not null default 10,
    "regolamento_path" text,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_leghe" enable row level security;


  create table "public"."fantacalcio_membri_lega" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "lega_id" uuid not null,
    "user_id" uuid not null,
    "ruolo" text not null default 'partecipante'::text,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_membri_lega" enable row level security;


  create table "public"."fantacalcio_partite" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "lega_id" uuid not null,
    "giornata_id" uuid not null,
    "squadra_casa_id" uuid not null,
    "squadra_ospite_id" uuid not null,
    "data_ora" timestamp with time zone,
    "risultato_casa" integer,
    "risultato_ospite" integer,
    "punti_casa" numeric(10,2),
    "punti_ospite" numeric(10,2),
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_partite" enable row level security;


  create table "public"."fantacalcio_rose_squadre" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "squadra_id" uuid not null,
    "calciatore_id" uuid not null,
    "acquistato_per" numeric(10,2),
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_rose_squadre" enable row level security;


  create table "public"."fantacalcio_squadre" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "lega_id" uuid not null,
    "nome" text not null,
    "proprietario_id" uuid not null,
    "logo_url" text,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_squadre" enable row level security;


  create table "public"."fantacalcio_voti_calciatori" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "calciatore_id" uuid not null,
    "partita_id" uuid not null,
    "voto" numeric(4,2) not null,
    "gol_fatti" integer not null default 0,
    "assist" integer not null default 0,
    "ammonizioni" integer not null default 0,
    "espulsioni" integer not null default 0,
    "autogol" integer not null default 0,
    "rigori_sbagliati" integer not null default 0,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."fantacalcio_voti_calciatori" enable row level security;


  create table "public"."profiles" (
    "id" uuid not null,
    "username" text,
    "avatar_url" text,
    "ruolo" text not null default 'utente'::text,
    "created_at" timestamp with time zone not null default timezone('utc'::text, now()),
    "updated_at" timestamp with time zone not null default timezone('utc'::text, now())
      );


alter table "public"."profiles" enable row level security;

CREATE UNIQUE INDEX fantacalcio_calciatori_pkey ON public.fantacalcio_calciatori USING btree (id);

CREATE INDEX fantacalcio_commenti_documenti_doc_idx ON public.fantacalcio_commenti_documenti USING btree (documento_id, created_at DESC);

CREATE UNIQUE INDEX fantacalcio_commenti_documenti_pkey ON public.fantacalcio_commenti_documenti USING btree (id);

CREATE INDEX fantacalcio_documenti_categoria_idx ON public.fantacalcio_documenti USING btree (categoria);

CREATE INDEX fantacalcio_documenti_lega_idx ON public.fantacalcio_documenti USING btree (lega_id);

CREATE UNIQUE INDEX fantacalcio_documenti_pkey ON public.fantacalcio_documenti USING btree (id);

CREATE UNIQUE INDEX fantacalcio_giornate_lega_id_numero_key ON public.fantacalcio_giornate USING btree (lega_id, numero);

CREATE UNIQUE INDEX fantacalcio_giornate_pkey ON public.fantacalcio_giornate USING btree (id);

CREATE INDEX fantacalcio_leghe_creatore_idx ON public.fantacalcio_leghe USING btree (creatore_id);

CREATE UNIQUE INDEX fantacalcio_leghe_pkey ON public.fantacalcio_leghe USING btree (id);

CREATE INDEX fantacalcio_leghe_stagione_idx ON public.fantacalcio_leghe USING btree (stagione);

CREATE UNIQUE INDEX fantacalcio_membri_lega_lega_id_user_id_key ON public.fantacalcio_membri_lega USING btree (lega_id, user_id);

CREATE UNIQUE INDEX fantacalcio_membri_lega_pkey ON public.fantacalcio_membri_lega USING btree (id);

CREATE INDEX fantacalcio_membri_lega_user_idx ON public.fantacalcio_membri_lega USING btree (user_id);

CREATE INDEX fantacalcio_partite_giornata_idx ON public.fantacalcio_partite USING btree (giornata_id);

CREATE INDEX fantacalcio_partite_lega_idx ON public.fantacalcio_partite USING btree (lega_id);

CREATE UNIQUE INDEX fantacalcio_partite_pkey ON public.fantacalcio_partite USING btree (id);

CREATE UNIQUE INDEX fantacalcio_rose_squadre_pkey ON public.fantacalcio_rose_squadre USING btree (id);

CREATE UNIQUE INDEX fantacalcio_rose_squadre_squadra_id_calciatore_id_key ON public.fantacalcio_rose_squadre USING btree (squadra_id, calciatore_id);

CREATE UNIQUE INDEX fantacalcio_squadre_lega_id_nome_key ON public.fantacalcio_squadre USING btree (lega_id, nome);

CREATE INDEX fantacalcio_squadre_lega_idx ON public.fantacalcio_squadre USING btree (lega_id);

CREATE UNIQUE INDEX fantacalcio_squadre_pkey ON public.fantacalcio_squadre USING btree (id);

CREATE INDEX fantacalcio_squadre_proprietario_idx ON public.fantacalcio_squadre USING btree (proprietario_id);

CREATE UNIQUE INDEX fantacalcio_voti_calciatori_calciatore_id_partita_id_key ON public.fantacalcio_voti_calciatori USING btree (calciatore_id, partita_id);

CREATE UNIQUE INDEX fantacalcio_voti_calciatori_pkey ON public.fantacalcio_voti_calciatori USING btree (id);

CREATE UNIQUE INDEX profiles_pkey ON public.profiles USING btree (id);

CREATE INDEX profiles_ruolo_idx ON public.profiles USING btree (ruolo);

CREATE UNIQUE INDEX profiles_username_key ON public.profiles USING btree (username);

alter table "public"."fantacalcio_calciatori" add constraint "fantacalcio_calciatori_pkey" PRIMARY KEY using index "fantacalcio_calciatori_pkey";

alter table "public"."fantacalcio_commenti_documenti" add constraint "fantacalcio_commenti_documenti_pkey" PRIMARY KEY using index "fantacalcio_commenti_documenti_pkey";

alter table "public"."fantacalcio_documenti" add constraint "fantacalcio_documenti_pkey" PRIMARY KEY using index "fantacalcio_documenti_pkey";

alter table "public"."fantacalcio_giornate" add constraint "fantacalcio_giornate_pkey" PRIMARY KEY using index "fantacalcio_giornate_pkey";

alter table "public"."fantacalcio_leghe" add constraint "fantacalcio_leghe_pkey" PRIMARY KEY using index "fantacalcio_leghe_pkey";

alter table "public"."fantacalcio_membri_lega" add constraint "fantacalcio_membri_lega_pkey" PRIMARY KEY using index "fantacalcio_membri_lega_pkey";

alter table "public"."fantacalcio_partite" add constraint "fantacalcio_partite_pkey" PRIMARY KEY using index "fantacalcio_partite_pkey";

alter table "public"."fantacalcio_rose_squadre" add constraint "fantacalcio_rose_squadre_pkey" PRIMARY KEY using index "fantacalcio_rose_squadre_pkey";

alter table "public"."fantacalcio_squadre" add constraint "fantacalcio_squadre_pkey" PRIMARY KEY using index "fantacalcio_squadre_pkey";

alter table "public"."fantacalcio_voti_calciatori" add constraint "fantacalcio_voti_calciatori_pkey" PRIMARY KEY using index "fantacalcio_voti_calciatori_pkey";

alter table "public"."profiles" add constraint "profiles_pkey" PRIMARY KEY using index "profiles_pkey";

alter table "public"."fantacalcio_calciatori" add constraint "fantacalcio_calciatori_ruolo_check" CHECK ((ruolo = ANY (ARRAY['P'::text, 'D'::text, 'C'::text, 'A'::text]))) not valid;

alter table "public"."fantacalcio_calciatori" validate constraint "fantacalcio_calciatori_ruolo_check";

alter table "public"."fantacalcio_commenti_documenti" add constraint "fantacalcio_commenti_documenti_autore_id_fkey" FOREIGN KEY (autore_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_commenti_documenti" validate constraint "fantacalcio_commenti_documenti_autore_id_fkey";

alter table "public"."fantacalcio_commenti_documenti" add constraint "fantacalcio_commenti_documenti_documento_id_fkey" FOREIGN KEY (documento_id) REFERENCES public.fantacalcio_documenti(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_commenti_documenti" validate constraint "fantacalcio_commenti_documenti_documento_id_fkey";

alter table "public"."fantacalcio_documenti" add constraint "fantacalcio_documenti_autore_id_fkey" FOREIGN KEY (autore_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_documenti" validate constraint "fantacalcio_documenti_autore_id_fkey";

alter table "public"."fantacalcio_documenti" add constraint "fantacalcio_documenti_categoria_check" CHECK ((categoria = ANY (ARRAY['regolamento'::text, 'comunicazione'::text, 'altro'::text]))) not valid;

alter table "public"."fantacalcio_documenti" validate constraint "fantacalcio_documenti_categoria_check";

alter table "public"."fantacalcio_documenti" add constraint "fantacalcio_documenti_lega_id_fkey" FOREIGN KEY (lega_id) REFERENCES public.fantacalcio_leghe(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_documenti" validate constraint "fantacalcio_documenti_lega_id_fkey";

alter table "public"."fantacalcio_documenti" add constraint "fantacalcio_documenti_visibilita_check" CHECK ((visibilita = ANY (ARRAY['globale'::text, 'lega'::text]))) not valid;

alter table "public"."fantacalcio_documenti" validate constraint "fantacalcio_documenti_visibilita_check";

alter table "public"."fantacalcio_giornate" add constraint "fantacalcio_giornate_lega_id_fkey" FOREIGN KEY (lega_id) REFERENCES public.fantacalcio_leghe(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_giornate" validate constraint "fantacalcio_giornate_lega_id_fkey";

alter table "public"."fantacalcio_giornate" add constraint "fantacalcio_giornate_lega_id_numero_key" UNIQUE using index "fantacalcio_giornate_lega_id_numero_key";

alter table "public"."fantacalcio_giornate" add constraint "fantacalcio_giornate_numero_check" CHECK ((numero > 0)) not valid;

alter table "public"."fantacalcio_giornate" validate constraint "fantacalcio_giornate_numero_check";

alter table "public"."fantacalcio_giornate" add constraint "fantacalcio_giornate_stato_check" CHECK ((stato = ANY (ARRAY['bozza'::text, 'pubblicata'::text, 'chiusa'::text]))) not valid;

alter table "public"."fantacalcio_giornate" validate constraint "fantacalcio_giornate_stato_check";

alter table "public"."fantacalcio_leghe" add constraint "fantacalcio_leghe_creatore_id_fkey" FOREIGN KEY (creatore_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_leghe" validate constraint "fantacalcio_leghe_creatore_id_fkey";

alter table "public"."fantacalcio_leghe" add constraint "fantacalcio_leghe_max_squadre_check" CHECK ((max_squadre > 1)) not valid;

alter table "public"."fantacalcio_leghe" validate constraint "fantacalcio_leghe_max_squadre_check";

alter table "public"."fantacalcio_membri_lega" add constraint "fantacalcio_membri_lega_lega_id_fkey" FOREIGN KEY (lega_id) REFERENCES public.fantacalcio_leghe(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_membri_lega" validate constraint "fantacalcio_membri_lega_lega_id_fkey";

alter table "public"."fantacalcio_membri_lega" add constraint "fantacalcio_membri_lega_lega_id_user_id_key" UNIQUE using index "fantacalcio_membri_lega_lega_id_user_id_key";

alter table "public"."fantacalcio_membri_lega" add constraint "fantacalcio_membri_lega_ruolo_check" CHECK ((ruolo = ANY (ARRAY['partecipante'::text, 'gestore'::text]))) not valid;

alter table "public"."fantacalcio_membri_lega" validate constraint "fantacalcio_membri_lega_ruolo_check";

alter table "public"."fantacalcio_membri_lega" add constraint "fantacalcio_membri_lega_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_membri_lega" validate constraint "fantacalcio_membri_lega_user_id_fkey";

alter table "public"."fantacalcio_partite" add constraint "fantacalcio_partite_giornata_id_fkey" FOREIGN KEY (giornata_id) REFERENCES public.fantacalcio_giornate(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_partite" validate constraint "fantacalcio_partite_giornata_id_fkey";

alter table "public"."fantacalcio_partite" add constraint "fantacalcio_partite_lega_id_fkey" FOREIGN KEY (lega_id) REFERENCES public.fantacalcio_leghe(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_partite" validate constraint "fantacalcio_partite_lega_id_fkey";

alter table "public"."fantacalcio_partite" add constraint "fantacalcio_partite_squadra_casa_id_fkey" FOREIGN KEY (squadra_casa_id) REFERENCES public.fantacalcio_squadre(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_partite" validate constraint "fantacalcio_partite_squadra_casa_id_fkey";

alter table "public"."fantacalcio_partite" add constraint "fantacalcio_partite_squadra_ospite_id_fkey" FOREIGN KEY (squadra_ospite_id) REFERENCES public.fantacalcio_squadre(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_partite" validate constraint "fantacalcio_partite_squadra_ospite_id_fkey";

alter table "public"."fantacalcio_rose_squadre" add constraint "fantacalcio_rose_squadre_calciatore_id_fkey" FOREIGN KEY (calciatore_id) REFERENCES public.fantacalcio_calciatori(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_rose_squadre" validate constraint "fantacalcio_rose_squadre_calciatore_id_fkey";

alter table "public"."fantacalcio_rose_squadre" add constraint "fantacalcio_rose_squadre_squadra_id_calciatore_id_key" UNIQUE using index "fantacalcio_rose_squadre_squadra_id_calciatore_id_key";

alter table "public"."fantacalcio_rose_squadre" add constraint "fantacalcio_rose_squadre_squadra_id_fkey" FOREIGN KEY (squadra_id) REFERENCES public.fantacalcio_squadre(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_rose_squadre" validate constraint "fantacalcio_rose_squadre_squadra_id_fkey";

alter table "public"."fantacalcio_squadre" add constraint "fantacalcio_squadre_lega_id_fkey" FOREIGN KEY (lega_id) REFERENCES public.fantacalcio_leghe(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_squadre" validate constraint "fantacalcio_squadre_lega_id_fkey";

alter table "public"."fantacalcio_squadre" add constraint "fantacalcio_squadre_lega_id_nome_key" UNIQUE using index "fantacalcio_squadre_lega_id_nome_key";

alter table "public"."fantacalcio_squadre" add constraint "fantacalcio_squadre_proprietario_id_fkey" FOREIGN KEY (proprietario_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_squadre" validate constraint "fantacalcio_squadre_proprietario_id_fkey";

alter table "public"."fantacalcio_voti_calciatori" add constraint "fantacalcio_voti_calciatori_calciatore_id_fkey" FOREIGN KEY (calciatore_id) REFERENCES public.fantacalcio_calciatori(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_voti_calciatori" validate constraint "fantacalcio_voti_calciatori_calciatore_id_fkey";

alter table "public"."fantacalcio_voti_calciatori" add constraint "fantacalcio_voti_calciatori_calciatore_id_partita_id_key" UNIQUE using index "fantacalcio_voti_calciatori_calciatore_id_partita_id_key";

alter table "public"."fantacalcio_voti_calciatori" add constraint "fantacalcio_voti_calciatori_partita_id_fkey" FOREIGN KEY (partita_id) REFERENCES public.fantacalcio_partite(id) ON DELETE CASCADE not valid;

alter table "public"."fantacalcio_voti_calciatori" validate constraint "fantacalcio_voti_calciatori_partita_id_fkey";

alter table "public"."profiles" add constraint "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."profiles" validate constraint "profiles_id_fkey";

alter table "public"."profiles" add constraint "profiles_ruolo_check" CHECK ((ruolo = ANY (ARRAY['utente'::text, 'gestore'::text, 'admin'::text]))) not valid;

alter table "public"."profiles" validate constraint "profiles_ruolo_check";

alter table "public"."profiles" add constraint "profiles_username_key" UNIQUE using index "profiles_username_key";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.set_private_item_owner_id()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  IF NEW.owner_id IS NULL AND auth.uid() IS NOT NULL THEN
    NEW.owner_id := auth.uid();
  END IF;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = timezone('utc', now());
  RETURN NEW;
END;
$function$
;

grant delete on table "public"."fantacalcio_calciatori" to "anon";

grant insert on table "public"."fantacalcio_calciatori" to "anon";

grant references on table "public"."fantacalcio_calciatori" to "anon";

grant select on table "public"."fantacalcio_calciatori" to "anon";

grant trigger on table "public"."fantacalcio_calciatori" to "anon";

grant truncate on table "public"."fantacalcio_calciatori" to "anon";

grant update on table "public"."fantacalcio_calciatori" to "anon";

grant delete on table "public"."fantacalcio_calciatori" to "authenticated";

grant insert on table "public"."fantacalcio_calciatori" to "authenticated";

grant references on table "public"."fantacalcio_calciatori" to "authenticated";

grant select on table "public"."fantacalcio_calciatori" to "authenticated";

grant trigger on table "public"."fantacalcio_calciatori" to "authenticated";

grant truncate on table "public"."fantacalcio_calciatori" to "authenticated";

grant update on table "public"."fantacalcio_calciatori" to "authenticated";

grant delete on table "public"."fantacalcio_calciatori" to "service_role";

grant insert on table "public"."fantacalcio_calciatori" to "service_role";

grant references on table "public"."fantacalcio_calciatori" to "service_role";

grant select on table "public"."fantacalcio_calciatori" to "service_role";

grant trigger on table "public"."fantacalcio_calciatori" to "service_role";

grant truncate on table "public"."fantacalcio_calciatori" to "service_role";

grant update on table "public"."fantacalcio_calciatori" to "service_role";

grant delete on table "public"."fantacalcio_commenti_documenti" to "anon";

grant insert on table "public"."fantacalcio_commenti_documenti" to "anon";

grant references on table "public"."fantacalcio_commenti_documenti" to "anon";

grant select on table "public"."fantacalcio_commenti_documenti" to "anon";

grant trigger on table "public"."fantacalcio_commenti_documenti" to "anon";

grant truncate on table "public"."fantacalcio_commenti_documenti" to "anon";

grant update on table "public"."fantacalcio_commenti_documenti" to "anon";

grant delete on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant insert on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant references on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant select on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant trigger on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant truncate on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant update on table "public"."fantacalcio_commenti_documenti" to "authenticated";

grant delete on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant insert on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant references on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant select on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant trigger on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant truncate on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant update on table "public"."fantacalcio_commenti_documenti" to "service_role";

grant delete on table "public"."fantacalcio_documenti" to "anon";

grant insert on table "public"."fantacalcio_documenti" to "anon";

grant references on table "public"."fantacalcio_documenti" to "anon";

grant select on table "public"."fantacalcio_documenti" to "anon";

grant trigger on table "public"."fantacalcio_documenti" to "anon";

grant truncate on table "public"."fantacalcio_documenti" to "anon";

grant update on table "public"."fantacalcio_documenti" to "anon";

grant delete on table "public"."fantacalcio_documenti" to "authenticated";

grant insert on table "public"."fantacalcio_documenti" to "authenticated";

grant references on table "public"."fantacalcio_documenti" to "authenticated";

grant select on table "public"."fantacalcio_documenti" to "authenticated";

grant trigger on table "public"."fantacalcio_documenti" to "authenticated";

grant truncate on table "public"."fantacalcio_documenti" to "authenticated";

grant update on table "public"."fantacalcio_documenti" to "authenticated";

grant delete on table "public"."fantacalcio_documenti" to "service_role";

grant insert on table "public"."fantacalcio_documenti" to "service_role";

grant references on table "public"."fantacalcio_documenti" to "service_role";

grant select on table "public"."fantacalcio_documenti" to "service_role";

grant trigger on table "public"."fantacalcio_documenti" to "service_role";

grant truncate on table "public"."fantacalcio_documenti" to "service_role";

grant update on table "public"."fantacalcio_documenti" to "service_role";

grant delete on table "public"."fantacalcio_giornate" to "anon";

grant insert on table "public"."fantacalcio_giornate" to "anon";

grant references on table "public"."fantacalcio_giornate" to "anon";

grant select on table "public"."fantacalcio_giornate" to "anon";

grant trigger on table "public"."fantacalcio_giornate" to "anon";

grant truncate on table "public"."fantacalcio_giornate" to "anon";

grant update on table "public"."fantacalcio_giornate" to "anon";

grant delete on table "public"."fantacalcio_giornate" to "authenticated";

grant insert on table "public"."fantacalcio_giornate" to "authenticated";

grant references on table "public"."fantacalcio_giornate" to "authenticated";

grant select on table "public"."fantacalcio_giornate" to "authenticated";

grant trigger on table "public"."fantacalcio_giornate" to "authenticated";

grant truncate on table "public"."fantacalcio_giornate" to "authenticated";

grant update on table "public"."fantacalcio_giornate" to "authenticated";

grant delete on table "public"."fantacalcio_giornate" to "service_role";

grant insert on table "public"."fantacalcio_giornate" to "service_role";

grant references on table "public"."fantacalcio_giornate" to "service_role";

grant select on table "public"."fantacalcio_giornate" to "service_role";

grant trigger on table "public"."fantacalcio_giornate" to "service_role";

grant truncate on table "public"."fantacalcio_giornate" to "service_role";

grant update on table "public"."fantacalcio_giornate" to "service_role";

grant delete on table "public"."fantacalcio_leghe" to "anon";

grant insert on table "public"."fantacalcio_leghe" to "anon";

grant references on table "public"."fantacalcio_leghe" to "anon";

grant select on table "public"."fantacalcio_leghe" to "anon";

grant trigger on table "public"."fantacalcio_leghe" to "anon";

grant truncate on table "public"."fantacalcio_leghe" to "anon";

grant update on table "public"."fantacalcio_leghe" to "anon";

grant delete on table "public"."fantacalcio_leghe" to "authenticated";

grant insert on table "public"."fantacalcio_leghe" to "authenticated";

grant references on table "public"."fantacalcio_leghe" to "authenticated";

grant select on table "public"."fantacalcio_leghe" to "authenticated";

grant trigger on table "public"."fantacalcio_leghe" to "authenticated";

grant truncate on table "public"."fantacalcio_leghe" to "authenticated";

grant update on table "public"."fantacalcio_leghe" to "authenticated";

grant delete on table "public"."fantacalcio_leghe" to "service_role";

grant insert on table "public"."fantacalcio_leghe" to "service_role";

grant references on table "public"."fantacalcio_leghe" to "service_role";

grant select on table "public"."fantacalcio_leghe" to "service_role";

grant trigger on table "public"."fantacalcio_leghe" to "service_role";

grant truncate on table "public"."fantacalcio_leghe" to "service_role";

grant update on table "public"."fantacalcio_leghe" to "service_role";

grant delete on table "public"."fantacalcio_membri_lega" to "anon";

grant insert on table "public"."fantacalcio_membri_lega" to "anon";

grant references on table "public"."fantacalcio_membri_lega" to "anon";

grant select on table "public"."fantacalcio_membri_lega" to "anon";

grant trigger on table "public"."fantacalcio_membri_lega" to "anon";

grant truncate on table "public"."fantacalcio_membri_lega" to "anon";

grant update on table "public"."fantacalcio_membri_lega" to "anon";

grant delete on table "public"."fantacalcio_membri_lega" to "authenticated";

grant insert on table "public"."fantacalcio_membri_lega" to "authenticated";

grant references on table "public"."fantacalcio_membri_lega" to "authenticated";

grant select on table "public"."fantacalcio_membri_lega" to "authenticated";

grant trigger on table "public"."fantacalcio_membri_lega" to "authenticated";

grant truncate on table "public"."fantacalcio_membri_lega" to "authenticated";

grant update on table "public"."fantacalcio_membri_lega" to "authenticated";

grant delete on table "public"."fantacalcio_membri_lega" to "service_role";

grant insert on table "public"."fantacalcio_membri_lega" to "service_role";

grant references on table "public"."fantacalcio_membri_lega" to "service_role";

grant select on table "public"."fantacalcio_membri_lega" to "service_role";

grant trigger on table "public"."fantacalcio_membri_lega" to "service_role";

grant truncate on table "public"."fantacalcio_membri_lega" to "service_role";

grant update on table "public"."fantacalcio_membri_lega" to "service_role";

grant delete on table "public"."fantacalcio_partite" to "anon";

grant insert on table "public"."fantacalcio_partite" to "anon";

grant references on table "public"."fantacalcio_partite" to "anon";

grant select on table "public"."fantacalcio_partite" to "anon";

grant trigger on table "public"."fantacalcio_partite" to "anon";

grant truncate on table "public"."fantacalcio_partite" to "anon";

grant update on table "public"."fantacalcio_partite" to "anon";

grant delete on table "public"."fantacalcio_partite" to "authenticated";

grant insert on table "public"."fantacalcio_partite" to "authenticated";

grant references on table "public"."fantacalcio_partite" to "authenticated";

grant select on table "public"."fantacalcio_partite" to "authenticated";

grant trigger on table "public"."fantacalcio_partite" to "authenticated";

grant truncate on table "public"."fantacalcio_partite" to "authenticated";

grant update on table "public"."fantacalcio_partite" to "authenticated";

grant delete on table "public"."fantacalcio_partite" to "service_role";

grant insert on table "public"."fantacalcio_partite" to "service_role";

grant references on table "public"."fantacalcio_partite" to "service_role";

grant select on table "public"."fantacalcio_partite" to "service_role";

grant trigger on table "public"."fantacalcio_partite" to "service_role";

grant truncate on table "public"."fantacalcio_partite" to "service_role";

grant update on table "public"."fantacalcio_partite" to "service_role";

grant delete on table "public"."fantacalcio_rose_squadre" to "anon";

grant insert on table "public"."fantacalcio_rose_squadre" to "anon";

grant references on table "public"."fantacalcio_rose_squadre" to "anon";

grant select on table "public"."fantacalcio_rose_squadre" to "anon";

grant trigger on table "public"."fantacalcio_rose_squadre" to "anon";

grant truncate on table "public"."fantacalcio_rose_squadre" to "anon";

grant update on table "public"."fantacalcio_rose_squadre" to "anon";

grant delete on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant insert on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant references on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant select on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant trigger on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant truncate on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant update on table "public"."fantacalcio_rose_squadre" to "authenticated";

grant delete on table "public"."fantacalcio_rose_squadre" to "service_role";

grant insert on table "public"."fantacalcio_rose_squadre" to "service_role";

grant references on table "public"."fantacalcio_rose_squadre" to "service_role";

grant select on table "public"."fantacalcio_rose_squadre" to "service_role";

grant trigger on table "public"."fantacalcio_rose_squadre" to "service_role";

grant truncate on table "public"."fantacalcio_rose_squadre" to "service_role";

grant update on table "public"."fantacalcio_rose_squadre" to "service_role";

grant delete on table "public"."fantacalcio_squadre" to "anon";

grant insert on table "public"."fantacalcio_squadre" to "anon";

grant references on table "public"."fantacalcio_squadre" to "anon";

grant select on table "public"."fantacalcio_squadre" to "anon";

grant trigger on table "public"."fantacalcio_squadre" to "anon";

grant truncate on table "public"."fantacalcio_squadre" to "anon";

grant update on table "public"."fantacalcio_squadre" to "anon";

grant delete on table "public"."fantacalcio_squadre" to "authenticated";

grant insert on table "public"."fantacalcio_squadre" to "authenticated";

grant references on table "public"."fantacalcio_squadre" to "authenticated";

grant select on table "public"."fantacalcio_squadre" to "authenticated";

grant trigger on table "public"."fantacalcio_squadre" to "authenticated";

grant truncate on table "public"."fantacalcio_squadre" to "authenticated";

grant update on table "public"."fantacalcio_squadre" to "authenticated";

grant delete on table "public"."fantacalcio_squadre" to "service_role";

grant insert on table "public"."fantacalcio_squadre" to "service_role";

grant references on table "public"."fantacalcio_squadre" to "service_role";

grant select on table "public"."fantacalcio_squadre" to "service_role";

grant trigger on table "public"."fantacalcio_squadre" to "service_role";

grant truncate on table "public"."fantacalcio_squadre" to "service_role";

grant update on table "public"."fantacalcio_squadre" to "service_role";

grant delete on table "public"."fantacalcio_voti_calciatori" to "anon";

grant insert on table "public"."fantacalcio_voti_calciatori" to "anon";

grant references on table "public"."fantacalcio_voti_calciatori" to "anon";

grant select on table "public"."fantacalcio_voti_calciatori" to "anon";

grant trigger on table "public"."fantacalcio_voti_calciatori" to "anon";

grant truncate on table "public"."fantacalcio_voti_calciatori" to "anon";

grant update on table "public"."fantacalcio_voti_calciatori" to "anon";

grant delete on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant insert on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant references on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant select on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant trigger on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant truncate on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant update on table "public"."fantacalcio_voti_calciatori" to "authenticated";

grant delete on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant insert on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant references on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant select on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant trigger on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant truncate on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant update on table "public"."fantacalcio_voti_calciatori" to "service_role";

grant delete on table "public"."profiles" to "anon";

grant insert on table "public"."profiles" to "anon";

grant references on table "public"."profiles" to "anon";

grant select on table "public"."profiles" to "anon";

grant trigger on table "public"."profiles" to "anon";

grant truncate on table "public"."profiles" to "anon";

grant update on table "public"."profiles" to "anon";

grant delete on table "public"."profiles" to "authenticated";

grant insert on table "public"."profiles" to "authenticated";

grant references on table "public"."profiles" to "authenticated";

grant select on table "public"."profiles" to "authenticated";

grant trigger on table "public"."profiles" to "authenticated";

grant truncate on table "public"."profiles" to "authenticated";

grant update on table "public"."profiles" to "authenticated";

grant delete on table "public"."profiles" to "service_role";

grant insert on table "public"."profiles" to "service_role";

grant references on table "public"."profiles" to "service_role";

grant select on table "public"."profiles" to "service_role";

grant trigger on table "public"."profiles" to "service_role";

grant truncate on table "public"."profiles" to "service_role";

grant update on table "public"."profiles" to "service_role";


  create policy "fantacalcio_calciatori_select_policy"
  on "public"."fantacalcio_calciatori"
  as permissive
  for select
  to public
using (((auth.uid() IS NOT NULL) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_calciatori_write_policy"
  on "public"."fantacalcio_calciatori"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.id = auth.uid()) AND (p.ruolo = 'admin'::text))))))
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.id = auth.uid()) AND (p.ruolo = 'admin'::text))))));



  create policy "fantacalcio_commenti_documenti_delete_policy"
  on "public"."fantacalcio_commenti_documenti"
  as permissive
  for delete
  to public
using (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_commenti_documenti_insert_policy"
  on "public"."fantacalcio_commenti_documenti"
  as permissive
  for insert
  to public
with check (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_commenti_documenti_select_policy"
  on "public"."fantacalcio_commenti_documenti"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_documenti d
  WHERE (d.id = fantacalcio_commenti_documenti.documento_id)))));



  create policy "fantacalcio_commenti_documenti_update_policy"
  on "public"."fantacalcio_commenti_documenti"
  as permissive
  for update
  to public
using (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)))
with check (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_documenti_delete_policy"
  on "public"."fantacalcio_documenti"
  as permissive
  for delete
  to public
using (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_documenti_insert_policy"
  on "public"."fantacalcio_documenti"
  as permissive
  for insert
  to public
with check (((autore_id = auth.uid()) AND ((auth.role() = 'service_role'::text) OR ((visibilita = 'globale'::text) AND (EXISTS ( SELECT 1
   FROM public.profiles p
  WHERE ((p.id = auth.uid()) AND (p.ruolo = 'admin'::text))))) OR ((lega_id IS NOT NULL) AND ((EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_documenti.lega_id) AND (l.creatore_id = auth.uid())))) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = ml.lega_id) AND (ml.user_id = auth.uid()) AND (ml.ruolo = 'gestore'::text)))))))));



  create policy "fantacalcio_documenti_select_policy"
  on "public"."fantacalcio_documenti"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (autore_id = auth.uid()) OR (visibilita = 'globale'::text) OR ((lega_id IS NOT NULL) AND (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = fantacalcio_documenti.lega_id) AND (ml.user_id = auth.uid())))))));



  create policy "fantacalcio_documenti_update_policy"
  on "public"."fantacalcio_documenti"
  as permissive
  for update
  to public
using (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)))
with check (((autore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_giornate_select_policy"
  on "public"."fantacalcio_giornate"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = fantacalcio_giornate.lega_id) AND (ml.user_id = auth.uid()))))));



  create policy "fantacalcio_giornate_write_policy"
  on "public"."fantacalcio_giornate"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_giornate.lega_id) AND (l.creatore_id = auth.uid()))))))
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_giornate.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_leghe_delete_policy"
  on "public"."fantacalcio_leghe"
  as permissive
  for delete
  to public
using (((creatore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_leghe_insert_policy"
  on "public"."fantacalcio_leghe"
  as permissive
  for insert
  to public
with check (((creatore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_leghe_select_policy"
  on "public"."fantacalcio_leghe"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (creatore_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = fantacalcio_leghe.id) AND (ml.user_id = auth.uid()))))));



  create policy "fantacalcio_leghe_update_policy"
  on "public"."fantacalcio_leghe"
  as permissive
  for update
  to public
using (((creatore_id = auth.uid()) OR (auth.role() = 'service_role'::text)))
with check (((creatore_id = auth.uid()) OR (auth.role() = 'service_role'::text)));



  create policy "fantacalcio_membri_lega_delete_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for delete
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_membri_lega.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_membri_lega_insert_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for insert
  to public
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_membri_lega.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_membri_lega_select_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (user_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_membri_lega.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_membri_lega_update_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for update
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_membri_lega.lega_id) AND (l.creatore_id = auth.uid()))))))
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_membri_lega.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_partite_select_policy"
  on "public"."fantacalcio_partite"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = fantacalcio_partite.lega_id) AND (ml.user_id = auth.uid()))))));



  create policy "fantacalcio_partite_write_policy"
  on "public"."fantacalcio_partite"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_partite.lega_id) AND (l.creatore_id = auth.uid()))))))
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_partite.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_rose_squadre_select_policy"
  on "public"."fantacalcio_rose_squadre"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_squadre s
  WHERE ((s.id = fantacalcio_rose_squadre.squadra_id) AND ((s.proprietario_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.fantacalcio_membri_lega ml
          WHERE ((ml.lega_id = s.lega_id) AND (ml.user_id = auth.uid()))))))))));



  create policy "fantacalcio_rose_squadre_write_policy"
  on "public"."fantacalcio_rose_squadre"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_squadre s
  WHERE ((s.id = fantacalcio_rose_squadre.squadra_id) AND (s.proprietario_id = auth.uid()))))))
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_squadre s
  WHERE ((s.id = fantacalcio_rose_squadre.squadra_id) AND (s.proprietario_id = auth.uid()))))));



  create policy "fantacalcio_squadre_delete_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for delete
  to public
using (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_squadre.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_squadre_insert_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for insert
  to public
with check (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = fantacalcio_squadre.lega_id) AND (ml.user_id = auth.uid()) AND (ml.ruolo = 'gestore'::text))))));



  create policy "fantacalcio_squadre_select_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_membri_lega ml
  WHERE ((ml.lega_id = fantacalcio_squadre.lega_id) AND (ml.user_id = auth.uid()))))));



  create policy "fantacalcio_squadre_update_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for update
  to public
using (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_squadre.lega_id) AND (l.creatore_id = auth.uid()))))))
with check (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.fantacalcio_leghe l
  WHERE ((l.id = fantacalcio_squadre.lega_id) AND (l.creatore_id = auth.uid()))))));



  create policy "fantacalcio_voti_calciatori_select_policy"
  on "public"."fantacalcio_voti_calciatori"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM (public.fantacalcio_partite p
     JOIN public.fantacalcio_membri_lega ml ON ((ml.lega_id = p.lega_id)))
  WHERE ((p.id = fantacalcio_voti_calciatori.partita_id) AND (ml.user_id = auth.uid()))))));



  create policy "fantacalcio_voti_calciatori_write_policy"
  on "public"."fantacalcio_voti_calciatori"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM (public.fantacalcio_partite p
     JOIN public.fantacalcio_leghe l ON ((l.id = p.lega_id)))
  WHERE ((p.id = fantacalcio_voti_calciatori.partita_id) AND (l.creatore_id = auth.uid()))))))
with check (((auth.role() = 'service_role'::text) OR (EXISTS ( SELECT 1
   FROM (public.fantacalcio_partite p
     JOIN public.fantacalcio_leghe l ON ((l.id = p.lega_id)))
  WHERE ((p.id = fantacalcio_voti_calciatori.partita_id) AND (l.creatore_id = auth.uid()))))));



  create policy "profiles_delete_policy"
  on "public"."profiles"
  as permissive
  for delete
  to public
using (((auth.uid() = id) OR (auth.role() = 'service_role'::text)));



  create policy "profiles_insert_policy"
  on "public"."profiles"
  as permissive
  for insert
  to public
with check (((auth.uid() = id) OR (auth.role() = 'service_role'::text)));



  create policy "profiles_select_policy"
  on "public"."profiles"
  as permissive
  for select
  to public
using (((auth.uid() = id) OR (auth.role() = 'service_role'::text)));



  create policy "profiles_update_policy"
  on "public"."profiles"
  as permissive
  for update
  to public
using (((auth.uid() = id) OR (auth.role() = 'service_role'::text)))
with check (((auth.uid() = id) OR (auth.role() = 'service_role'::text)));


CREATE TRIGGER set_updated_at_fantacalcio_commenti_documenti BEFORE UPDATE ON public.fantacalcio_commenti_documenti FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_fantacalcio_documenti BEFORE UPDATE ON public.fantacalcio_documenti FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_fantacalcio_leghe BEFORE UPDATE ON public.fantacalcio_leghe FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_fantacalcio_partite BEFORE UPDATE ON public.fantacalcio_partite FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_fantacalcio_squadre BEFORE UPDATE ON public.fantacalcio_squadre FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_updated_at_profiles BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


