export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      content_blog_post_comments: {
        Row: {
          author_id: string
          blog_post_id: string
          body: string
          created_at: string
          id: string
          updated_at: string
        }
        Insert: {
          author_id: string
          blog_post_id: string
          body: string
          created_at?: string
          id?: string
          updated_at?: string
        }
        Update: {
          author_id?: string
          blog_post_id?: string
          body?: string
          created_at?: string
          id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "content_blog_post_comments_blog_post_id_fkey"
            columns: ["blog_post_id"]
            isOneToOne: false
            referencedRelation: "content_blog_posts"
            referencedColumns: ["id"]
          },
        ]
      }
      content_blog_posts: {
        Row: {
          author_id: string
          body: string
          created_at: string
          excerpt: string | null
          id: string
          is_published: boolean
          published_at: string | null
          slug: string
          title: string
          updated_at: string
        }
        Insert: {
          author_id: string
          body: string
          created_at?: string
          excerpt?: string | null
          id?: string
          is_published?: boolean
          published_at?: string | null
          slug: string
          title: string
          updated_at?: string
        }
        Update: {
          author_id?: string
          body?: string
          created_at?: string
          excerpt?: string | null
          id?: string
          is_published?: boolean
          published_at?: string | null
          slug?: string
          title?: string
          updated_at?: string
        }
        Relationships: []
      }
      fantacalcio_calciatori: {
        Row: {
          created_at: string
          id: string
          nome: string
          ruolo: string
          squadra_reale: string
          valore_iniziale: number | null
        }
        Insert: {
          created_at?: string
          id?: string
          nome: string
          ruolo: string
          squadra_reale: string
          valore_iniziale?: number | null
        }
        Update: {
          created_at?: string
          id?: string
          nome?: string
          ruolo?: string
          squadra_reale?: string
          valore_iniziale?: number | null
        }
        Relationships: []
      }
      fantacalcio_commenti_documenti: {
        Row: {
          autore_id: string
          created_at: string
          documento_id: string
          id: string
          testo: string
          updated_at: string
        }
        Insert: {
          autore_id: string
          created_at?: string
          documento_id: string
          id?: string
          testo: string
          updated_at?: string
        }
        Update: {
          autore_id?: string
          created_at?: string
          documento_id?: string
          id?: string
          testo?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_commenti_documenti_documento_id_fkey"
            columns: ["documento_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_documenti"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_documenti: {
        Row: {
          autore_id: string
          categoria: string
          created_at: string
          descrizione: string | null
          file_path: string
          id: string
          lega_id: string | null
          titolo: string
          updated_at: string
          visibilita: string
        }
        Insert: {
          autore_id: string
          categoria?: string
          created_at?: string
          descrizione?: string | null
          file_path: string
          id?: string
          lega_id?: string | null
          titolo: string
          updated_at?: string
          visibilita?: string
        }
        Update: {
          autore_id?: string
          categoria?: string
          created_at?: string
          descrizione?: string | null
          file_path?: string
          id?: string
          lega_id?: string | null
          titolo?: string
          updated_at?: string
          visibilita?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_documenti_lega_id_fkey"
            columns: ["lega_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_leghe"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_giornate: {
        Row: {
          created_at: string
          id: string
          lega_id: string
          numero: number
          stato: string
        }
        Insert: {
          created_at?: string
          id?: string
          lega_id: string
          numero: number
          stato?: string
        }
        Update: {
          created_at?: string
          id?: string
          lega_id?: string
          numero?: number
          stato?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_giornate_lega_id_fkey"
            columns: ["lega_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_leghe"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_leghe: {
        Row: {
          created_at: string
          creatore_id: string
          data_fine: string | null
          data_inizio: string | null
          descrizione: string | null
          id: string
          max_squadre: number
          nome: string
          regolamento_path: string | null
          stagione: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          creatore_id: string
          data_fine?: string | null
          data_inizio?: string | null
          descrizione?: string | null
          id?: string
          max_squadre?: number
          nome: string
          regolamento_path?: string | null
          stagione?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          creatore_id?: string
          data_fine?: string | null
          data_inizio?: string | null
          descrizione?: string | null
          id?: string
          max_squadre?: number
          nome?: string
          regolamento_path?: string | null
          stagione?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      fantacalcio_membri_lega: {
        Row: {
          created_at: string
          id: string
          lega_id: string
          ruolo: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          lega_id: string
          ruolo?: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          lega_id?: string
          ruolo?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_membri_lega_lega_id_fkey"
            columns: ["lega_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_leghe"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_partite: {
        Row: {
          created_at: string
          data_ora: string | null
          giornata_id: string
          id: string
          lega_id: string
          punti_casa: number | null
          punti_ospite: number | null
          risultato_casa: number | null
          risultato_ospite: number | null
          squadra_casa_id: string
          squadra_ospite_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          data_ora?: string | null
          giornata_id: string
          id?: string
          lega_id: string
          punti_casa?: number | null
          punti_ospite?: number | null
          risultato_casa?: number | null
          risultato_ospite?: number | null
          squadra_casa_id: string
          squadra_ospite_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          data_ora?: string | null
          giornata_id?: string
          id?: string
          lega_id?: string
          punti_casa?: number | null
          punti_ospite?: number | null
          risultato_casa?: number | null
          risultato_ospite?: number | null
          squadra_casa_id?: string
          squadra_ospite_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_partite_giornata_id_fkey"
            columns: ["giornata_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_giornate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantacalcio_partite_lega_id_fkey"
            columns: ["lega_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_leghe"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantacalcio_partite_squadra_casa_id_fkey"
            columns: ["squadra_casa_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_squadre"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantacalcio_partite_squadra_ospite_id_fkey"
            columns: ["squadra_ospite_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_squadre"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_rose_squadre: {
        Row: {
          acquistato_per: number | null
          calciatore_id: string
          created_at: string
          id: string
          squadra_id: string
        }
        Insert: {
          acquistato_per?: number | null
          calciatore_id: string
          created_at?: string
          id?: string
          squadra_id: string
        }
        Update: {
          acquistato_per?: number | null
          calciatore_id?: string
          created_at?: string
          id?: string
          squadra_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_rose_squadre_calciatore_id_fkey"
            columns: ["calciatore_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_calciatori"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantacalcio_rose_squadre_squadra_id_fkey"
            columns: ["squadra_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_squadre"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_squadre: {
        Row: {
          created_at: string
          id: string
          lega_id: string
          logo_url: string | null
          nome: string
          proprietario_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          lega_id: string
          logo_url?: string | null
          nome: string
          proprietario_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          lega_id?: string
          logo_url?: string | null
          nome?: string
          proprietario_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_squadre_lega_id_fkey"
            columns: ["lega_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_leghe"
            referencedColumns: ["id"]
          },
        ]
      }
      fantacalcio_voti_calciatori: {
        Row: {
          ammonizioni: number
          assist: number
          autogol: number
          calciatore_id: string
          created_at: string
          espulsioni: number
          gol_fatti: number
          id: string
          partita_id: string
          rigori_sbagliati: number
          voto: number
        }
        Insert: {
          ammonizioni?: number
          assist?: number
          autogol?: number
          calciatore_id: string
          created_at?: string
          espulsioni?: number
          gol_fatti?: number
          id?: string
          partita_id: string
          rigori_sbagliati?: number
          voto: number
        }
        Update: {
          ammonizioni?: number
          assist?: number
          autogol?: number
          calciatore_id?: string
          created_at?: string
          espulsioni?: number
          gol_fatti?: number
          id?: string
          partita_id?: string
          rigori_sbagliati?: number
          voto?: number
        }
        Relationships: [
          {
            foreignKeyName: "fantacalcio_voti_calciatori_calciatore_id_fkey"
            columns: ["calciatore_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_calciatori"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fantacalcio_voti_calciatori_partita_id_fkey"
            columns: ["partita_id"]
            isOneToOne: false
            referencedRelation: "fantacalcio_partite"
            referencedColumns: ["id"]
          },
        ]
      }
      private_items: {
        Row: {
          created_at: string
          description: string
          id: string
          name: string
          owner_id: string | null
        }
        Insert: {
          created_at?: string
          description: string
          id?: string
          name: string
          owner_id?: string | null
        }
        Update: {
          created_at?: string
          description?: string
          id?: string
          name?: string
          owner_id?: string | null
        }
        Relationships: []
      }
      profiles: {
        Row: {
          avatar_url: string | null
          created_at: string
          id: string
          ruolo: string
          updated_at: string
          username: string | null
        }
        Insert: {
          avatar_url?: string | null
          created_at?: string
          id: string
          ruolo?: string
          updated_at?: string
          username?: string | null
        }
        Update: {
          avatar_url?: string | null
          created_at?: string
          id?: string
          ruolo?: string
          updated_at?: string
          username?: string | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      fantacalcio_is_admin: { Args: { p_user_id: string }; Returns: boolean }
      fantacalcio_is_creatore_lega: {
        Args: { p_lega_id: string; p_user_id: string }
        Returns: boolean
      }
      fantacalcio_is_gestore_lega: {
        Args: { p_lega_id: string; p_user_id: string }
        Returns: boolean
      }
      fantacalcio_is_membro_lega: {
        Args: { p_lega_id: string; p_user_id: string }
        Returns: boolean
      }
      fantacalcio_is_proprietario_squadra: {
        Args: { p_squadra_id: string; p_user_id: string }
        Returns: boolean
      }
      fantacalcio_lega_di_partita: {
        Args: { p_partita_id: string }
        Returns: string
      }
      fantacalcio_puo_vedere_documento: {
        Args: { p_documento_id: string; p_user_id: string }
        Returns: boolean
      }
      fantacalcio_puo_vedere_squadra: {
        Args: { p_squadra_id: string; p_user_id: string }
        Returns: boolean
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
