BEGIN;

SELECT plan(34);

-- =============================================================================
-- Fantacalcio: policy RLS
--
-- Questi test coprono due cose che la suite principale non verificava:
--
--  1. le query sulle tabelle `fantacalcio_*` non sollevano l'errore 42P17
--     ("infinite recursion detected in policy"). La ricorsione si manifesta
--     solo quando la RLS viene davvero valutata, quindi i controlli devono
--     girare come ruolo `authenticated` e non come `postgres` (che ha
--     BYPASSRLS e non valuterebbe alcuna policy);
--  2. le policy filtrano ancora i dati: chi non appartiene a una lega non
--     deve vedere nulla.
--
-- I dati di prova sono inseriti come `postgres` prima di cambiare ruolo.
-- =============================================================================

-- ---------- Setup: utenti ----------
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at,
  raw_app_meta_data, raw_user_meta_data
) VALUES
  ('aaaa1111-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pgtap-a@example.com', '', now(), now(), now(), '{}', '{}'),
  ('bbbb2222-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pgtap-b@example.com', '', now(), now(), now(), '{}', '{}'),
  ('cccc3333-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pgtap-c@example.com', '', now(), now(), now(), '{}', '{}'),
  ('dddd4444-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pgtap-gestore@example.com', '', now(), now(), now(), '{}', '{}'),
  ('eeee5555-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pgtap-admin@example.com', '', now(), now(), now(), '{}', '{}');

-- `public.profiles` non viene popolata automaticamente alla registrazione
-- (non esiste un trigger su `auth.users`), quindi la riga va creata qui.
INSERT INTO public.profiles (id, username, ruolo)
VALUES ('eeee5555-0000-0000-0000-000000000005', 'pgtap-admin', 'admin');

-- ---------- Setup: lega, membri, squadre, competizione ----------
INSERT INTO public.fantacalcio_leghe (id, nome, creatore_id, stagione)
VALUES ('11112222-0000-0000-0000-000000000001', 'PGTAP Lega', 'aaaa1111-0000-0000-0000-000000000001', '2026/27');

INSERT INTO public.fantacalcio_membri_lega (lega_id, user_id, ruolo) VALUES
  ('11112222-0000-0000-0000-000000000001', 'bbbb2222-0000-0000-0000-000000000002', 'partecipante'),
  ('11112222-0000-0000-0000-000000000001', 'dddd4444-0000-0000-0000-000000000004', 'gestore');

INSERT INTO public.fantacalcio_squadre (id, lega_id, nome, proprietario_id) VALUES
  ('33334444-0000-0000-0000-000000000001', '11112222-0000-0000-0000-000000000001', 'Squadra B', 'bbbb2222-0000-0000-0000-000000000002'),
  ('33334444-0000-0000-0000-000000000002', '11112222-0000-0000-0000-000000000001', 'Squadra Gestore', 'dddd4444-0000-0000-0000-000000000004');

INSERT INTO public.fantacalcio_giornate (id, lega_id, numero, stato)
VALUES ('55556666-0000-0000-0000-000000000001', '11112222-0000-0000-0000-000000000001', 1, 'pubblicata');

INSERT INTO public.fantacalcio_partite (
  id, lega_id, giornata_id, squadra_casa_id, squadra_ospite_id
) VALUES (
  '77778888-0000-0000-0000-000000000001',
  '11112222-0000-0000-0000-000000000001',
  '55556666-0000-0000-0000-000000000001',
  '33334444-0000-0000-0000-000000000001',
  '33334444-0000-0000-0000-000000000002'
);

INSERT INTO public.fantacalcio_calciatori (id, nome, ruolo, squadra_reale)
VALUES ('99990000-0000-0000-0000-000000000001', 'Calciatore Test', 'A', 'Squadra Reale');

INSERT INTO public.fantacalcio_voti_calciatori (calciatore_id, partita_id, voto)
VALUES (
  '99990000-0000-0000-0000-000000000001',
  '77778888-0000-0000-0000-000000000001',
  7.5
);

INSERT INTO public.fantacalcio_documenti (
  id, titolo, categoria, visibilita, file_path, autore_id, lega_id
) VALUES
  ('aabb0000-0000-0000-0000-000000000001', 'Documento di lega', 'regolamento', 'lega', 'a/doc-l.pdf',    'bbbb2222-0000-0000-0000-000000000002', '11112222-0000-0000-0000-000000000001'),
  ('aabb0000-0000-0000-0000-000000000002', 'Documento globale', 'comunicazione', 'globale', 'a/doc-glob.pdf', 'eeee5555-0000-0000-0000-000000000005', NULL);

INSERT INTO public.fantacalcio_commenti_documenti (documento_id, autore_id, testo)
VALUES ('aabb0000-0000-0000-0000-000000000001', 'bbbb2222-0000-0000-0000-000000000002', 'Commento test');

-- =============================================================================
-- 1. Regressione: nessuna ricorsione (errore 42P17) con RLS attiva
-- =============================================================================
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"aaaa1111-0000-0000-0000-000000000001","role":"authenticated"}';

SELECT lives_ok('SELECT 1 FROM public.fantacalcio_leghe',              'fantacalcio_leghe non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_membri_lega',        'fantacalcio_membri_lega non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_squadre',            'fantacalcio_squadre non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_rose_squadre',       'fantacalcio_rose_squadre non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_giornate',           'fantacalcio_giornate non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_partite',            'fantacalcio_partite non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_voti_calciatori',    'fantacalcio_voti_calciatori non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_documenti',          'fantacalcio_documenti non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_commenti_documenti', 'fantacalcio_commenti_documenti non deve sollevare 42P17');
SELECT lives_ok('SELECT 1 FROM public.fantacalcio_calciatori',         'fantacalcio_calciatori non deve sollevare 42P17');

-- =============================================================================
-- 2. Visibilita' per il creatore della lega (utente A)
-- =============================================================================
SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_leghe WHERE id = '11112222-0000-0000-0000-000000000001'$$,
  ARRAY[1::bigint],
  'Il creatore vede la propria lega'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_membri_lega WHERE lega_id = '11112222-0000-0000-0000-000000000001'$$,
  ARRAY[2::bigint],
  'Il creatore vede i membri della propria lega'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_squadre WHERE lega_id = '11112222-0000-0000-0000-000000000001'$$,
  ARRAY[0::bigint],
  'Il creatore non e'' membro della lega, quindi non vede le squadre (modello dati attuale)'
);

RESET ROLE;

-- =============================================================================
-- 3. Visibilita' per un membro (utente B)
-- =============================================================================
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"bbbb2222-0000-0000-0000-000000000002","role":"authenticated"}';

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_leghe WHERE id = '11112222-0000-0000-0000-000000000001'$$,
  ARRAY[1::bigint],
  'Il membro vede la lega a cui appartiene'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_squadre WHERE lega_id = '11112222-0000-0000-0000-000000000001'$$,
  ARRAY[2::bigint],
  'Il membro vede le squadre della propria lega'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_giornate WHERE lega_id = '11112222-0000-0000-0000-000000000001'$$,
  ARRAY[1::bigint],
  'Il membro vede le giornate della propria lega'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_voti_calciatori WHERE partita_id = '77778888-0000-0000-0000-000000000001'$$,
  ARRAY[1::bigint],
  'Il membro vede i voti delle partite della propria lega'
);

RESET ROLE;

-- =============================================================================
-- 4. Visibilita' per un estraneo (utente C): nessun accesso
-- =============================================================================
SET LOCAL ROLE authenticated;
SET LOCAL request.jwt.claims = '{"sub":"cccc3333-0000-0000-0000-000000000003","role":"authenticated"}';

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_leghe$$,
  ARRAY[0::bigint],
  'Un estraneo non vede alcuna lega'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_membri_lega$$,
  ARRAY[0::bigint],
  'Un estraneo non vede alcun membro'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_squadre$$,
  ARRAY[0::bigint],
  'Un estraneo non vede alcuna squadra'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_partite$$,
  ARRAY[0::bigint],
  'Un estraneo non vede alcuna partita'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_commenti_documenti$$,
  ARRAY[0::bigint],
  'Un estraneo non vede commenti di documenti non visibili'
);

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_documenti WHERE visibilita = 'globale'$$,
  ARRAY[1::bigint],
  'Un estraneo vede comunque i documenti contrassegnati come globali'
);

RESET ROLE;

-- =============================================================================
-- 5. Utente anonimo: nessun accesso
-- =============================================================================
SET LOCAL ROLE anon;
SET LOCAL request.jwt.claims = '{"role":"anon"}';

SELECT results_eq(
  $$SELECT count(*) FROM public.fantacalcio_leghe$$,
  ARRAY[0::bigint],
  'Un utente anonimo non vede alcuna lega'
);

RESET ROLE;

-- =============================================================================
-- 6. Funzioni di supporto delle policy
-- =============================================================================
SELECT ok(
  public.fantacalcio_is_membro_lega('11112222-0000-0000-0000-000000000001', 'bbbb2222-0000-0000-0000-000000000002'),
  'fantacalcio_is_membro_lega riconosce un membro'
);

SELECT ok(
  NOT public.fantacalcio_is_membro_lega('11112222-0000-0000-0000-000000000001', 'cccc3333-0000-0000-0000-000000000003'),
  'fantacalcio_is_membro_lega esclude un estraneo'
);

SELECT ok(
  public.fantacalcio_is_creatore_lega('11112222-0000-0000-0000-000000000001', 'aaaa1111-0000-0000-0000-000000000001'),
  'fantacalcio_is_creatore_lega riconosce il creatore'
);

SELECT ok(
  NOT public.fantacalcio_is_creatore_lega('11112222-0000-0000-0000-000000000001', 'cccc3333-0000-0000-0000-000000000003'),
  'fantacalcio_is_creatore_lega esclude un estraneo'
);

SELECT ok(
  public.fantacalcio_is_gestore_lega('11112222-0000-0000-0000-000000000001', 'dddd4444-0000-0000-0000-000000000004'),
  'fantacalcio_is_gestore_lega riconosce un gestore'
);

SELECT ok(
  NOT public.fantacalcio_is_gestore_lega('11112222-0000-0000-0000-000000000001', 'bbbb2222-0000-0000-0000-000000000002'),
  'fantacalcio_is_gestore_lega esclude un semplice partecipante'
);

SELECT ok(
  public.fantacalcio_is_admin('eeee5555-0000-0000-0000-000000000005'),
  'fantacalcio_is_admin riconosce un amministratore'
);

SELECT ok(
  NOT public.fantacalcio_is_admin('aaaa1111-0000-0000-0000-000000000001'),
  'fantacalcio_is_admin esclude un utente normale'
);

SELECT ok(
  public.fantacalcio_lega_di_partita('77778888-0000-0000-0000-000000000001') = '11112222-0000-0000-0000-000000000001'::uuid,
  'fantacalcio_lega_di_partita risolve la lega di una partita'
);

SELECT ok(
  NOT public.fantacalcio_is_membro_lega(NULL, 'bbbb2222-0000-0000-0000-000000000002'),
  'fantacalcio_is_membro_lega con lega NULL restituisce false'
);

SELECT *
FROM finish();

ROLLBACK;
