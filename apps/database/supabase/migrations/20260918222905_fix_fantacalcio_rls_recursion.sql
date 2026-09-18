drop policy "fantacalcio_calciatori_write_policy" on "public"."fantacalcio_calciatori";

drop policy "fantacalcio_commenti_documenti_select_policy" on "public"."fantacalcio_commenti_documenti";

drop policy "fantacalcio_documenti_insert_policy" on "public"."fantacalcio_documenti";

drop policy "fantacalcio_documenti_select_policy" on "public"."fantacalcio_documenti";

drop policy "fantacalcio_giornate_select_policy" on "public"."fantacalcio_giornate";

drop policy "fantacalcio_giornate_write_policy" on "public"."fantacalcio_giornate";

drop policy "fantacalcio_leghe_select_policy" on "public"."fantacalcio_leghe";

drop policy "fantacalcio_membri_lega_delete_policy" on "public"."fantacalcio_membri_lega";

drop policy "fantacalcio_membri_lega_insert_policy" on "public"."fantacalcio_membri_lega";

drop policy "fantacalcio_membri_lega_select_policy" on "public"."fantacalcio_membri_lega";

drop policy "fantacalcio_membri_lega_update_policy" on "public"."fantacalcio_membri_lega";

drop policy "fantacalcio_partite_select_policy" on "public"."fantacalcio_partite";

drop policy "fantacalcio_partite_write_policy" on "public"."fantacalcio_partite";

drop policy "fantacalcio_rose_squadre_select_policy" on "public"."fantacalcio_rose_squadre";

drop policy "fantacalcio_rose_squadre_write_policy" on "public"."fantacalcio_rose_squadre";

drop policy "fantacalcio_squadre_delete_policy" on "public"."fantacalcio_squadre";

drop policy "fantacalcio_squadre_insert_policy" on "public"."fantacalcio_squadre";

drop policy "fantacalcio_squadre_select_policy" on "public"."fantacalcio_squadre";

drop policy "fantacalcio_squadre_update_policy" on "public"."fantacalcio_squadre";

drop policy "fantacalcio_voti_calciatori_select_policy" on "public"."fantacalcio_voti_calciatori";

drop policy "fantacalcio_voti_calciatori_write_policy" on "public"."fantacalcio_voti_calciatori";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.fantacalcio_is_admin(p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = p_user_id
      AND p.ruolo = 'admin'
  );
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_is_creatore_lega(p_lega_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.fantacalcio_leghe l
    WHERE l.id = p_lega_id
      AND l.creatore_id = p_user_id
  );
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_is_gestore_lega(p_lega_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.fantacalcio_membri_lega ml
    WHERE ml.lega_id = p_lega_id
      AND ml.user_id = p_user_id
      AND ml.ruolo = 'gestore'
  );
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_is_membro_lega(p_lega_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.fantacalcio_membri_lega ml
    WHERE ml.lega_id = p_lega_id
      AND ml.user_id = p_user_id
  );
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_is_proprietario_squadra(p_squadra_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.fantacalcio_squadre s
    WHERE s.id = p_squadra_id
      AND s.proprietario_id = p_user_id
  );
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_lega_di_partita(p_partita_id uuid)
 RETURNS uuid
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT p.lega_id
  FROM public.fantacalcio_partite p
  WHERE p.id = p_partita_id;
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_puo_vedere_documento(p_documento_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.fantacalcio_documenti d
    WHERE d.id = p_documento_id
      AND (
        d.autore_id = p_user_id
        OR d.visibilita = 'globale'
        OR (
          d.lega_id IS NOT NULL
          AND public.fantacalcio_is_membro_lega(d.lega_id, p_user_id)
        )
      )
  );
$function$
;

CREATE OR REPLACE FUNCTION public.fantacalcio_puo_vedere_squadra(p_squadra_id uuid, p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.fantacalcio_squadre s
    WHERE s.id = p_squadra_id
      AND (
        s.proprietario_id = p_user_id
        OR public.fantacalcio_is_membro_lega(s.lega_id, p_user_id)
      )
  );
$function$
;


  create policy "fantacalcio_calciatori_write_policy"
  on "public"."fantacalcio_calciatori"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_admin(auth.uid())))
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_admin(auth.uid())));



  create policy "fantacalcio_commenti_documenti_select_policy"
  on "public"."fantacalcio_commenti_documenti"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_puo_vedere_documento(documento_id, auth.uid())));



  create policy "fantacalcio_documenti_insert_policy"
  on "public"."fantacalcio_documenti"
  as permissive
  for insert
  to public
with check (((autore_id = auth.uid()) AND ((auth.role() = 'service_role'::text) OR ((visibilita = 'globale'::text) AND public.fantacalcio_is_admin(auth.uid())) OR ((lega_id IS NOT NULL) AND (public.fantacalcio_is_creatore_lega(lega_id, auth.uid()) OR public.fantacalcio_is_gestore_lega(lega_id, auth.uid()))))));



  create policy "fantacalcio_documenti_select_policy"
  on "public"."fantacalcio_documenti"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (autore_id = auth.uid()) OR (visibilita = 'globale'::text) OR public.fantacalcio_is_membro_lega(lega_id, auth.uid())));



  create policy "fantacalcio_giornate_select_policy"
  on "public"."fantacalcio_giornate"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_membro_lega(lega_id, auth.uid())));



  create policy "fantacalcio_giornate_write_policy"
  on "public"."fantacalcio_giornate"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())))
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_leghe_select_policy"
  on "public"."fantacalcio_leghe"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (creatore_id = auth.uid()) OR public.fantacalcio_is_membro_lega(id, auth.uid())));



  create policy "fantacalcio_membri_lega_delete_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for delete
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_membri_lega_insert_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for insert
  to public
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_membri_lega_select_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (user_id = auth.uid()) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_membri_lega_update_policy"
  on "public"."fantacalcio_membri_lega"
  as permissive
  for update
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())))
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_partite_select_policy"
  on "public"."fantacalcio_partite"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_membro_lega(lega_id, auth.uid())));



  create policy "fantacalcio_partite_write_policy"
  on "public"."fantacalcio_partite"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())))
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_rose_squadre_select_policy"
  on "public"."fantacalcio_rose_squadre"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_puo_vedere_squadra(squadra_id, auth.uid())));



  create policy "fantacalcio_rose_squadre_write_policy"
  on "public"."fantacalcio_rose_squadre"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_proprietario_squadra(squadra_id, auth.uid())))
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_proprietario_squadra(squadra_id, auth.uid())));



  create policy "fantacalcio_squadre_delete_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for delete
  to public
using (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_squadre_insert_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for insert
  to public
with check (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR public.fantacalcio_is_gestore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_squadre_select_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR public.fantacalcio_is_membro_lega(lega_id, auth.uid())));



  create policy "fantacalcio_squadre_update_policy"
  on "public"."fantacalcio_squadre"
  as permissive
  for update
  to public
using (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())))
with check (((auth.role() = 'service_role'::text) OR (proprietario_id = auth.uid()) OR public.fantacalcio_is_creatore_lega(lega_id, auth.uid())));



  create policy "fantacalcio_voti_calciatori_select_policy"
  on "public"."fantacalcio_voti_calciatori"
  as permissive
  for select
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_membro_lega(public.fantacalcio_lega_di_partita(partita_id), auth.uid())));



  create policy "fantacalcio_voti_calciatori_write_policy"
  on "public"."fantacalcio_voti_calciatori"
  as permissive
  for all
  to public
using (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(public.fantacalcio_lega_di_partita(partita_id), auth.uid())))
with check (((auth.role() = 'service_role'::text) OR public.fantacalcio_is_creatore_lega(public.fantacalcio_lega_di_partita(partita_id), auth.uid())));



