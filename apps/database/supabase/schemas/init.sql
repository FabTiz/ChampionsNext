-- =============================================================================
-- Extensions
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

-- =============================================================================
-- Functions
-- =============================================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = timezone('utc', now());
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.set_private_item_owner_id()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NEW.owner_id IS NULL AND auth.uid() IS NOT NULL THEN
    NEW.owner_id := auth.uid();
  END IF;
  RETURN NEW;
END;
$$;

-- =============================================================================
-- Tables
-- =============================================================================

-- private_items: User-owned items with RLS
CREATE TABLE IF NOT EXISTS public.private_items (
  id uuid NOT NULL DEFAULT extensions.uuid_generate_v4(),
  created_at timestamptz NOT NULL DEFAULT now(),
  name character varying NOT NULL,
  description character varying NOT NULL,
  owner_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
  CONSTRAINT private_items_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_private_items_created_at
  ON public.private_items (created_at DESC);

CREATE INDEX IF NOT EXISTS idx_private_items_id_created_at
  ON public.private_items (id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_private_items_owner_id
  ON public.private_items (owner_id);

CREATE TRIGGER set_owner_id_on_insert
  BEFORE INSERT ON public.private_items
  FOR EACH ROW
  EXECUTE FUNCTION public.set_private_item_owner_id();

ALTER TABLE public.private_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_all_policy ON public.private_items
  FOR SELECT USING (TRUE);

CREATE POLICY insert_auth_policy ON public.private_items
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY update_own_policy ON public.private_items
  FOR UPDATE USING (auth.uid() = owner_id)
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY delete_own_policy ON public.private_items
  FOR DELETE USING (auth.uid() = owner_id);

-- =============================================================================
-- Blog: content_blog_posts
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.content_blog_posts (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  slug text NOT NULL,
  title text NOT NULL,
  excerpt text,
  body text NOT NULL,
  author_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  is_published boolean NOT NULL DEFAULT true,
  published_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE UNIQUE INDEX IF NOT EXISTS content_blog_posts_slug_key
  ON public.content_blog_posts (slug);

CREATE INDEX IF NOT EXISTS content_blog_posts_author_id_idx
  ON public.content_blog_posts (author_id);

CREATE INDEX IF NOT EXISTS content_blog_posts_published_at_idx
  ON public.content_blog_posts (is_published, published_at DESC);

CREATE TRIGGER set_updated_at_content_blog_posts
  BEFORE UPDATE ON public.content_blog_posts
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.content_blog_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY content_blog_posts_select_policy
  ON public.content_blog_posts
  FOR SELECT
  USING (is_published OR auth.uid() = author_id OR auth.role() = 'service_role');

CREATE POLICY content_blog_posts_insert_policy
  ON public.content_blog_posts
  FOR INSERT
  WITH CHECK (auth.uid() = author_id OR auth.role() = 'service_role');

CREATE POLICY content_blog_posts_update_policy
  ON public.content_blog_posts
  FOR UPDATE
  USING (auth.uid() = author_id OR auth.role() = 'service_role')
  WITH CHECK (auth.uid() = author_id OR auth.role() = 'service_role');

CREATE POLICY content_blog_posts_delete_policy
  ON public.content_blog_posts
  FOR DELETE
  USING (auth.uid() = author_id OR auth.role() = 'service_role');

-- =============================================================================
-- Blog: content_blog_post_comments
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.content_blog_post_comments (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  blog_post_id uuid NOT NULL REFERENCES public.content_blog_posts (id) ON DELETE CASCADE,
  author_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  body text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS content_blog_post_comments_post_id_idx
  ON public.content_blog_post_comments (blog_post_id, created_at DESC);

CREATE INDEX IF NOT EXISTS content_blog_post_comments_author_id_idx
  ON public.content_blog_post_comments (author_id);

CREATE TRIGGER set_updated_at_content_blog_post_comments
  BEFORE UPDATE ON public.content_blog_post_comments
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.content_blog_post_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY content_blog_post_comments_select_policy
  ON public.content_blog_post_comments
  FOR SELECT USING (TRUE);

CREATE POLICY content_blog_post_comments_insert_policy
  ON public.content_blog_post_comments
  FOR INSERT
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY content_blog_post_comments_update_policy
  ON public.content_blog_post_comments
  FOR UPDATE
  USING (auth.uid() = author_id)
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY content_blog_post_comments_delete_policy
  ON public.content_blog_post_comments
  FOR DELETE
  USING (auth.uid() = author_id);

-- =============================================================================
-- Fantacalcio: profiles
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  username text UNIQUE,
  avatar_url text,
  ruolo text NOT NULL DEFAULT 'utente' CHECK (ruolo IN ('utente', 'gestore', 'admin')),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS profiles_ruolo_idx
  ON public.profiles (ruolo);

CREATE TRIGGER set_updated_at_profiles
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY profiles_select_policy
  ON public.profiles
  FOR SELECT
  USING (auth.uid() = id OR auth.role() = 'service_role');

CREATE POLICY profiles_insert_policy
  ON public.profiles
  FOR INSERT
  WITH CHECK (auth.uid() = id OR auth.role() = 'service_role');

CREATE POLICY profiles_update_policy
  ON public.profiles
  FOR UPDATE
  USING (auth.uid() = id OR auth.role() = 'service_role')
  WITH CHECK (auth.uid() = id OR auth.role() = 'service_role');

CREATE POLICY profiles_delete_policy
  ON public.profiles
  FOR DELETE
  USING (auth.uid() = id OR auth.role() = 'service_role');

-- =============================================================================
-- Fantacalcio: Leghe e membri
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.fantacalcio_leghe (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  nome text NOT NULL,
  descrizione text,
  stagione text,
  creatore_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  data_inizio date,
  data_fine date,
  max_squadre integer NOT NULL DEFAULT 10 CHECK (max_squadre > 1),
  regolamento_path text,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS fantacalcio_leghe_creatore_idx
  ON public.fantacalcio_leghe (creatore_id);

CREATE INDEX IF NOT EXISTS fantacalcio_leghe_stagione_idx
  ON public.fantacalcio_leghe (stagione);

CREATE TRIGGER set_updated_at_fantacalcio_leghe
  BEFORE UPDATE ON public.fantacalcio_leghe
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.fantacalcio_membri_lega (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  lega_id uuid NOT NULL REFERENCES public.fantacalcio_leghe (id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  ruolo text NOT NULL DEFAULT 'partecipante' CHECK (ruolo IN ('partecipante', 'gestore')),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (lega_id, user_id)
);

CREATE INDEX IF NOT EXISTS fantacalcio_membri_lega_user_idx
  ON public.fantacalcio_membri_lega (user_id);

ALTER TABLE public.fantacalcio_leghe ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_membri_lega ENABLE ROW LEVEL SECURITY;

CREATE POLICY fantacalcio_leghe_select_policy
  ON public.fantacalcio_leghe
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR creatore_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_membri_lega ml
      WHERE ml.lega_id = public.fantacalcio_leghe.id
        AND ml.user_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_leghe_insert_policy
  ON public.fantacalcio_leghe
  FOR INSERT
  WITH CHECK (creatore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_leghe_update_policy
  ON public.fantacalcio_leghe
  FOR UPDATE
  USING (creatore_id = auth.uid() OR auth.role() = 'service_role')
  WITH CHECK (creatore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_leghe_delete_policy
  ON public.fantacalcio_leghe
  FOR DELETE
  USING (creatore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_membri_lega_select_policy
  ON public.fantacalcio_membri_lega
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR user_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_membri_lega.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_membri_lega_insert_policy
  ON public.fantacalcio_membri_lega
  FOR INSERT
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_membri_lega.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_membri_lega_update_policy
  ON public.fantacalcio_membri_lega
  FOR UPDATE
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_membri_lega.lega_id
        AND l.creatore_id = auth.uid()
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_membri_lega.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_membri_lega_delete_policy
  ON public.fantacalcio_membri_lega
  FOR DELETE
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_membri_lega.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

-- =============================================================================
-- Fantacalcio: Competizione
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.fantacalcio_squadre (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  lega_id uuid NOT NULL REFERENCES public.fantacalcio_leghe (id) ON DELETE CASCADE,
  nome text NOT NULL,
  proprietario_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  logo_url text,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (lega_id, nome)
);

CREATE INDEX IF NOT EXISTS fantacalcio_squadre_lega_idx
  ON public.fantacalcio_squadre (lega_id);

CREATE INDEX IF NOT EXISTS fantacalcio_squadre_proprietario_idx
  ON public.fantacalcio_squadre (proprietario_id);

CREATE TRIGGER set_updated_at_fantacalcio_squadre
  BEFORE UPDATE ON public.fantacalcio_squadre
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.fantacalcio_calciatori (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  nome text NOT NULL,
  ruolo text NOT NULL CHECK (ruolo IN ('P', 'D', 'C', 'A')),
  squadra_reale text NOT NULL,
  valore_iniziale numeric(10,2),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE TABLE IF NOT EXISTS public.fantacalcio_rose_squadre (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  squadra_id uuid NOT NULL REFERENCES public.fantacalcio_squadre (id) ON DELETE CASCADE,
  calciatore_id uuid NOT NULL REFERENCES public.fantacalcio_calciatori (id) ON DELETE CASCADE,
  acquistato_per numeric(10,2),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (squadra_id, calciatore_id)
);

CREATE TABLE IF NOT EXISTS public.fantacalcio_giornate (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  lega_id uuid NOT NULL REFERENCES public.fantacalcio_leghe (id) ON DELETE CASCADE,
  numero integer NOT NULL CHECK (numero > 0),
  stato text NOT NULL DEFAULT 'bozza' CHECK (stato IN ('bozza', 'pubblicata', 'chiusa')),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (lega_id, numero)
);

CREATE TABLE IF NOT EXISTS public.fantacalcio_partite (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  lega_id uuid NOT NULL REFERENCES public.fantacalcio_leghe (id) ON DELETE CASCADE,
  giornata_id uuid NOT NULL REFERENCES public.fantacalcio_giornate (id) ON DELETE CASCADE,
  squadra_casa_id uuid NOT NULL REFERENCES public.fantacalcio_squadre (id) ON DELETE CASCADE,
  squadra_ospite_id uuid NOT NULL REFERENCES public.fantacalcio_squadre (id) ON DELETE CASCADE,
  data_ora timestamptz,
  risultato_casa integer,
  risultato_ospite integer,
  punti_casa numeric(10,2),
  punti_ospite numeric(10,2),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS fantacalcio_partite_lega_idx
  ON public.fantacalcio_partite (lega_id);

CREATE INDEX IF NOT EXISTS fantacalcio_partite_giornata_idx
  ON public.fantacalcio_partite (giornata_id);

CREATE TRIGGER set_updated_at_fantacalcio_partite
  BEFORE UPDATE ON public.fantacalcio_partite
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.fantacalcio_voti_calciatori (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  calciatore_id uuid NOT NULL REFERENCES public.fantacalcio_calciatori (id) ON DELETE CASCADE,
  partita_id uuid NOT NULL REFERENCES public.fantacalcio_partite (id) ON DELETE CASCADE,
  voto numeric(4,2) NOT NULL,
  gol_fatti integer NOT NULL DEFAULT 0,
  assist integer NOT NULL DEFAULT 0,
  ammonizioni integer NOT NULL DEFAULT 0,
  espulsioni integer NOT NULL DEFAULT 0,
  autogol integer NOT NULL DEFAULT 0,
  rigori_sbagliati integer NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (calciatore_id, partita_id)
);

ALTER TABLE public.fantacalcio_squadre ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_calciatori ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_rose_squadre ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_giornate ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_partite ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_voti_calciatori ENABLE ROW LEVEL SECURITY;

CREATE POLICY fantacalcio_squadre_select_policy
  ON public.fantacalcio_squadre
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR proprietario_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_membri_lega ml
      WHERE ml.lega_id = public.fantacalcio_squadre.lega_id
        AND ml.user_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_squadre_insert_policy
  ON public.fantacalcio_squadre
  FOR INSERT
  WITH CHECK (
    auth.role() = 'service_role'
    OR proprietario_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_membri_lega ml
      WHERE ml.lega_id = public.fantacalcio_squadre.lega_id
        AND ml.user_id = auth.uid()
        AND ml.ruolo = 'gestore'
    )
  );

CREATE POLICY fantacalcio_squadre_update_policy
  ON public.fantacalcio_squadre
  FOR UPDATE
  USING (
    auth.role() = 'service_role'
    OR proprietario_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_squadre.lega_id
        AND l.creatore_id = auth.uid()
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR proprietario_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_squadre.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_squadre_delete_policy
  ON public.fantacalcio_squadre
  FOR DELETE
  USING (
    auth.role() = 'service_role'
    OR proprietario_id = auth.uid()
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_squadre.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_calciatori_select_policy
  ON public.fantacalcio_calciatori
  FOR SELECT
  USING (auth.uid() IS NOT NULL OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_calciatori_write_policy
  ON public.fantacalcio_calciatori
  FOR ALL
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.profiles p
      WHERE p.id = auth.uid() AND p.ruolo = 'admin'
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.profiles p
      WHERE p.id = auth.uid() AND p.ruolo = 'admin'
    )
  );

CREATE POLICY fantacalcio_rose_squadre_select_policy
  ON public.fantacalcio_rose_squadre
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_squadre s
      WHERE s.id = public.fantacalcio_rose_squadre.squadra_id
        AND (
          s.proprietario_id = auth.uid()
          OR EXISTS (
            SELECT 1
            FROM public.fantacalcio_membri_lega ml
            WHERE ml.lega_id = s.lega_id
              AND ml.user_id = auth.uid()
          )
        )
    )
  );

CREATE POLICY fantacalcio_rose_squadre_write_policy
  ON public.fantacalcio_rose_squadre
  FOR ALL
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_squadre s
      WHERE s.id = public.fantacalcio_rose_squadre.squadra_id
        AND s.proprietario_id = auth.uid()
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_squadre s
      WHERE s.id = public.fantacalcio_rose_squadre.squadra_id
        AND s.proprietario_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_giornate_select_policy
  ON public.fantacalcio_giornate
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_membri_lega ml
      WHERE ml.lega_id = public.fantacalcio_giornate.lega_id
        AND ml.user_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_giornate_write_policy
  ON public.fantacalcio_giornate
  FOR ALL
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_giornate.lega_id
        AND l.creatore_id = auth.uid()
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_giornate.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_partite_select_policy
  ON public.fantacalcio_partite
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_membri_lega ml
      WHERE ml.lega_id = public.fantacalcio_partite.lega_id
        AND ml.user_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_partite_write_policy
  ON public.fantacalcio_partite
  FOR ALL
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_partite.lega_id
        AND l.creatore_id = auth.uid()
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_leghe l
      WHERE l.id = public.fantacalcio_partite.lega_id
        AND l.creatore_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_voti_calciatori_select_policy
  ON public.fantacalcio_voti_calciatori
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_partite p
      JOIN public.fantacalcio_membri_lega ml ON ml.lega_id = p.lega_id
      WHERE p.id = public.fantacalcio_voti_calciatori.partita_id
        AND ml.user_id = auth.uid()
    )
  );

CREATE POLICY fantacalcio_voti_calciatori_write_policy
  ON public.fantacalcio_voti_calciatori
  FOR ALL
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_partite p
      JOIN public.fantacalcio_leghe l ON l.id = p.lega_id
      WHERE p.id = public.fantacalcio_voti_calciatori.partita_id
        AND l.creatore_id = auth.uid()
    )
  )
  WITH CHECK (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_partite p
      JOIN public.fantacalcio_leghe l ON l.id = p.lega_id
      WHERE p.id = public.fantacalcio_voti_calciatori.partita_id
        AND l.creatore_id = auth.uid()
    )
  );

-- =============================================================================
-- Fantacalcio: Bacheca documenti
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.fantacalcio_documenti (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  titolo text NOT NULL,
  descrizione text,
  categoria text NOT NULL DEFAULT 'altro' CHECK (categoria IN ('regolamento', 'comunicazione', 'altro')),
  visibilita text NOT NULL DEFAULT 'lega' CHECK (visibilita IN ('globale', 'lega')),
  file_path text NOT NULL,
  autore_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  lega_id uuid REFERENCES public.fantacalcio_leghe (id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS fantacalcio_documenti_categoria_idx
  ON public.fantacalcio_documenti (categoria);

CREATE INDEX IF NOT EXISTS fantacalcio_documenti_lega_idx
  ON public.fantacalcio_documenti (lega_id);

CREATE TRIGGER set_updated_at_fantacalcio_documenti
  BEFORE UPDATE ON public.fantacalcio_documenti
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.fantacalcio_commenti_documenti (
  id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
  documento_id uuid NOT NULL REFERENCES public.fantacalcio_documenti (id) ON DELETE CASCADE,
  autore_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  testo text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS fantacalcio_commenti_documenti_doc_idx
  ON public.fantacalcio_commenti_documenti (documento_id, created_at DESC);

CREATE TRIGGER set_updated_at_fantacalcio_commenti_documenti
  BEFORE UPDATE ON public.fantacalcio_commenti_documenti
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.fantacalcio_documenti ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fantacalcio_commenti_documenti ENABLE ROW LEVEL SECURITY;

CREATE POLICY fantacalcio_documenti_select_policy
  ON public.fantacalcio_documenti
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR autore_id = auth.uid()
    OR visibilita = 'globale'
    OR (
      lega_id IS NOT NULL
      AND EXISTS (
        SELECT 1
        FROM public.fantacalcio_membri_lega ml
        WHERE ml.lega_id = public.fantacalcio_documenti.lega_id
          AND ml.user_id = auth.uid()
      )
    )
  );

CREATE POLICY fantacalcio_documenti_insert_policy
  ON public.fantacalcio_documenti
  FOR INSERT
  WITH CHECK (
    autore_id = auth.uid()
    AND (
      auth.role() = 'service_role'
      OR (
        visibilita = 'globale'
        AND EXISTS (
          SELECT 1
          FROM public.profiles p
          WHERE p.id = auth.uid() AND p.ruolo = 'admin'
        )
      )
      OR (
        lega_id IS NOT NULL
        AND (
          EXISTS (
            SELECT 1
            FROM public.fantacalcio_leghe l
            WHERE l.id = lega_id
              AND l.creatore_id = auth.uid()
          )
          OR EXISTS (
            SELECT 1
            FROM public.fantacalcio_membri_lega ml
            WHERE ml.lega_id = lega_id
              AND ml.user_id = auth.uid()
              AND ml.ruolo = 'gestore'
          )
        )
      )
    )
  );

CREATE POLICY fantacalcio_documenti_update_policy
  ON public.fantacalcio_documenti
  FOR UPDATE
  USING (autore_id = auth.uid() OR auth.role() = 'service_role')
  WITH CHECK (autore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_documenti_delete_policy
  ON public.fantacalcio_documenti
  FOR DELETE
  USING (autore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_commenti_documenti_select_policy
  ON public.fantacalcio_commenti_documenti
  FOR SELECT
  USING (
    auth.role() = 'service_role'
    OR EXISTS (
      SELECT 1
      FROM public.fantacalcio_documenti d
      WHERE d.id = public.fantacalcio_commenti_documenti.documento_id
    )
  );

CREATE POLICY fantacalcio_commenti_documenti_insert_policy
  ON public.fantacalcio_commenti_documenti
  FOR INSERT
  WITH CHECK (autore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_commenti_documenti_update_policy
  ON public.fantacalcio_commenti_documenti
  FOR UPDATE
  USING (autore_id = auth.uid() OR auth.role() = 'service_role')
  WITH CHECK (autore_id = auth.uid() OR auth.role() = 'service_role');

CREATE POLICY fantacalcio_commenti_documenti_delete_policy
  ON public.fantacalcio_commenti_documenti
  FOR DELETE
  USING (autore_id = auth.uid() OR auth.role() = 'service_role');

-- =============================================================================
-- Grants: Schema usage
-- =============================================================================

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
GRANT USAGE ON SCHEMA "public" TO "supabase_auth_admin";

-- =============================================================================
-- Grants: Functions
-- =============================================================================

GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "service_role";

GRANT ALL ON FUNCTION "public"."set_private_item_owner_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_private_item_owner_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_private_item_owner_id"() TO "service_role";

-- =============================================================================
-- Grants: Tables
-- =============================================================================

GRANT ALL ON TABLE "public"."private_items" TO "anon";
GRANT ALL ON TABLE "public"."private_items" TO "authenticated";
GRANT ALL ON TABLE "public"."private_items" TO "service_role";

GRANT ALL ON TABLE "public"."content_blog_posts" TO "anon";
GRANT ALL ON TABLE "public"."content_blog_posts" TO "authenticated";
GRANT ALL ON TABLE "public"."content_blog_posts" TO "service_role";

GRANT ALL ON TABLE "public"."content_blog_post_comments" TO "anon";
GRANT ALL ON TABLE "public"."content_blog_post_comments" TO "authenticated";
GRANT ALL ON TABLE "public"."content_blog_post_comments" TO "service_role";

GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_leghe" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_leghe" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_leghe" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_membri_lega" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_membri_lega" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_membri_lega" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_squadre" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_squadre" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_squadre" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_calciatori" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_calciatori" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_calciatori" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_rose_squadre" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_rose_squadre" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_rose_squadre" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_giornate" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_giornate" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_giornate" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_partite" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_partite" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_partite" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_voti_calciatori" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_voti_calciatori" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_voti_calciatori" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_documenti" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_documenti" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_documenti" TO "service_role";

GRANT ALL ON TABLE "public"."fantacalcio_commenti_documenti" TO "anon";
GRANT ALL ON TABLE "public"."fantacalcio_commenti_documenti" TO "authenticated";
GRANT ALL ON TABLE "public"."fantacalcio_commenti_documenti" TO "service_role";

-- =============================================================================
-- Default privileges: future objects inherit grants automatically
-- =============================================================================

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";
