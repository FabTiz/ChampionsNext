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
      classifica_champions: {
        Row: {
          diff_fantapunti: number
          fantapunti_totali: number
          punti: number
          squad_id: number
        }
        Insert: {
          diff_fantapunti?: number
          fantapunti_totali?: number
          punti?: number
          squad_id: number
        }
        Update: {
          diff_fantapunti?: number
          fantapunti_totali?: number
          punti?: number
          squad_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "classifica_champions_squad_id_fkey"
            columns: ["squad_id"]
            isOneToOne: true
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
        ]
      }
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
      giornate: {
        Row: {
          id: number
          turno_id: number
        }
        Insert: {
          id: number
          turno_id: number
        }
        Update: {
          id?: number
          turno_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "giornate_turno_id_fkey"
            columns: ["turno_id"]
            isOneToOne: false
            referencedRelation: "turni"
            referencedColumns: ["id"]
          },
        ]
      }
      league_turn_details: {
        Row: {
          saved_at: string
          turn_number: number
          turn_state: Json
        }
        Insert: {
          saved_at?: string
          turn_number: number
          turn_state: Json
        }
        Update: {
          saved_at?: string
          turn_number?: number
          turn_state?: Json
        }
        Relationships: []
      }
      league_turns: {
        Row: {
          champions_points_away: number | null
          champions_points_home: number | null
          id: number
          matchday_1_points_away: number | null
          matchday_1_points_home: number | null
          matchday_2_points_away: number | null
          matchday_2_points_home: number | null
          matchday_3_points_away: number | null
          matchday_3_points_home: number | null
          result: string | null
          team_away_id: number
          team_home_id: number
          total_away: number | null
          total_home: number | null
          turn_number: number
        }
        Insert: {
          champions_points_away?: number | null
          champions_points_home?: number | null
          id?: number
          matchday_1_points_away?: number | null
          matchday_1_points_home?: number | null
          matchday_2_points_away?: number | null
          matchday_2_points_home?: number | null
          matchday_3_points_away?: number | null
          matchday_3_points_home?: number | null
          result?: string | null
          team_away_id: number
          team_home_id: number
          total_away?: number | null
          total_home?: number | null
          turn_number: number
        }
        Update: {
          champions_points_away?: number | null
          champions_points_home?: number | null
          id?: number
          matchday_1_points_away?: number | null
          matchday_1_points_home?: number | null
          matchday_2_points_away?: number | null
          matchday_2_points_home?: number | null
          matchday_3_points_away?: number | null
          matchday_3_points_home?: number | null
          result?: string | null
          team_away_id?: number
          team_home_id?: number
          total_away?: number | null
          total_home?: number | null
          turn_number?: number
        }
        Relationships: [
          {
            foreignKeyName: "league_turns_team_away_id_fkey"
            columns: ["team_away_id"]
            isOneToOne: false
            referencedRelation: "teams"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "league_turns_team_home_id_fkey"
            columns: ["team_home_id"]
            isOneToOne: false
            referencedRelation: "teams"
            referencedColumns: ["id"]
          },
        ]
      }
      matches: {
        Row: {
          away_team: number
          giornata: number
          home_team: number
          id: number
        }
        Insert: {
          away_team: number
          giornata: number
          home_team: number
          id?: never
        }
        Update: {
          away_team?: number
          giornata?: number
          home_team?: number
          id?: never
        }
        Relationships: [
          {
            foreignKeyName: "matches_away_team_fkey"
            columns: ["away_team"]
            isOneToOne: false
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "matches_giornata_fkey"
            columns: ["giornata"]
            isOneToOne: false
            referencedRelation: "giornate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "matches_home_team_fkey"
            columns: ["home_team"]
            isOneToOne: false
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
        ]
      }
      missioni_completate: {
        Row: {
          comune: boolean
          id: number
          leggendaria: boolean
          personale: boolean
          squad_id: number
          turno_id: number
        }
        Insert: {
          comune?: boolean
          id?: never
          leggendaria?: boolean
          personale?: boolean
          squad_id: number
          turno_id: number
        }
        Update: {
          comune?: boolean
          id?: never
          leggendaria?: boolean
          personale?: boolean
          squad_id?: number
          turno_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "missioni_completate_squad_id_fkey"
            columns: ["squad_id"]
            isOneToOne: false
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "missioni_completate_turno_id_fkey"
            columns: ["turno_id"]
            isOneToOne: false
            referencedRelation: "turni"
            referencedColumns: ["id"]
          },
        ]
      }
      missioni_parziali: {
        Row: {
          comune: boolean | null
          evento_speciale: boolean | null
          giornata: number
          id: number
          inserted_at: string | null
          personale_completata: boolean | null
          personale_scelta: string | null
          squad_id: number
          turno_id: number
          updated_at: string | null
          vittoria: boolean | null
          voti_bassi: boolean | null
        }
        Insert: {
          comune?: boolean | null
          evento_speciale?: boolean | null
          giornata: number
          id?: never
          inserted_at?: string | null
          personale_completata?: boolean | null
          personale_scelta?: string | null
          squad_id: number
          turno_id: number
          updated_at?: string | null
          vittoria?: boolean | null
          voti_bassi?: boolean | null
        }
        Update: {
          comune?: boolean | null
          evento_speciale?: boolean | null
          giornata?: number
          id?: never
          inserted_at?: string | null
          personale_completata?: boolean | null
          personale_scelta?: string | null
          squad_id?: number
          turno_id?: number
          updated_at?: string | null
          vittoria?: boolean | null
          voti_bassi?: boolean | null
        }
        Relationships: []
      }
      missioni_personali_scelte: {
        Row: {
          id: number
          missione: string
          squad_id: number
          turno_id: number
        }
        Insert: {
          id?: never
          missione: string
          squad_id: number
          turno_id: number
        }
        Update: {
          id?: never
          missione?: string
          squad_id?: number
          turno_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "missioni_personali_scelte_squad_id_fkey"
            columns: ["squad_id"]
            isOneToOne: false
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "missioni_personali_scelte_turno_id_fkey"
            columns: ["turno_id"]
            isOneToOne: false
            referencedRelation: "turni"
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
      punteggi_parziali: {
        Row: {
          giornata: number
          id: number
          inserted_at: string | null
          punteggio: number | null
          squad_id: number
          turno_id: number
          updated_at: string | null
        }
        Insert: {
          giornata: number
          id?: never
          inserted_at?: string | null
          punteggio?: number | null
          squad_id: number
          turno_id: number
          updated_at?: string | null
        }
        Update: {
          giornata?: number
          id?: never
          inserted_at?: string | null
          punteggio?: number | null
          squad_id?: number
          turno_id?: number
          updated_at?: string | null
        }
        Relationships: []
      }
      risultati: {
        Row: {
          assist: number
          evento_speciale: boolean | null
          fantapunti: number
          giornata: number
          gol: number
          id: number
          rigori_parati: number
          squad_id: number
          top4: boolean | null
          voti_bassi: number
        }
        Insert: {
          assist?: number
          evento_speciale?: boolean | null
          fantapunti: number
          giornata: number
          gol?: number
          id?: never
          rigori_parati?: number
          squad_id: number
          top4?: boolean | null
          voti_bassi?: number
        }
        Update: {
          assist?: number
          evento_speciale?: boolean | null
          fantapunti?: number
          giornata?: number
          gol?: number
          id?: never
          rigori_parati?: number
          squad_id?: number
          top4?: boolean | null
          voti_bassi?: number
        }
        Relationships: [
          {
            foreignKeyName: "risultati_giornata_fkey"
            columns: ["giornata"]
            isOneToOne: false
            referencedRelation: "giornate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "risultati_squad_id_fkey"
            columns: ["squad_id"]
            isOneToOne: false
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
        ]
      }
      squads: {
        Row: {
          id: number
          name: string
        }
        Insert: {
          id?: never
          name: string
        }
        Update: {
          id?: never
          name?: string
        }
        Relationships: []
      }
      teams: {
        Row: {
          id: number
          name: string
        }
        Insert: {
          id?: number
          name: string
        }
        Update: {
          id?: number
          name?: string
        }
        Relationships: []
      }
      turni: {
        Row: {
          id: number
          nome: string
        }
        Insert: {
          id: number
          nome: string
        }
        Update: {
          id?: number
          nome?: string
        }
        Relationships: []
      }
      uomo_champions: {
        Row: {
          bonus: number | null
          fase: string
          giocatore: string
          id: number
          malus: number | null
          ruolo: string
          squad_id: number
        }
        Insert: {
          bonus?: number | null
          fase: string
          giocatore: string
          id?: never
          malus?: number | null
          ruolo: string
          squad_id: number
        }
        Update: {
          bonus?: number | null
          fase?: string
          giocatore?: string
          id?: never
          malus?: number | null
          ruolo?: string
          squad_id?: number
        }
        Relationships: [
          {
            foreignKeyName: "uomo_champions_squad_id_fkey"
            columns: ["squad_id"]
            isOneToOne: false
            referencedRelation: "squads"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
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
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
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
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
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
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
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
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
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
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
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
