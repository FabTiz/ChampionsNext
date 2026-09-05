import { Separator } from '@/components/ui/separator';
import {
  CalendarDays,
  FileText,
  ShoppingCart,
  TrendingUp,
  Trophy,
  Users,
} from 'lucide-react';
import { HomeCTA } from './home-cta';
import { HomeFeatures, type HomeFeature } from './home-features';
import { HomeHero } from './home-hero';

const features: HomeFeature[] = [
  {
    icon: Trophy,
    title: 'Le tue leghe',
    description:
      'Crea e gestisci le tue leghe, con classifica rapida e accesso a tutti i dettagli della stagione.',
  },
  {
    icon: CalendarDays,
    title: 'Giornata corrente',
    description:
      'Risultati live, stato della formazione e punteggi in aggiornamento giornata dopo giornata.',
  },
  {
    icon: ShoppingCart,
    title: 'Mercato',
    description:
      'Offerte aperte, storico scambi e suggerimenti per rinforzare la tua rosa.',
  },
  {
    icon: Users,
    title: 'Squadre e rose',
    description:
      'Gestisci rose e formazioni delle squadre della tua lega in modo semplice e veloce.',
  },
  {
    icon: TrendingUp,
    title: 'Classifiche live',
    description:
      'Punteggi e posizioni sempre aggiornati, con confronto diretto tra le squadre.',
  },
  {
    icon: FileText,
    title: 'Bacheca e regolamenti',
    description:
      'Comunicazioni ufficiali, regolamenti e documenti condivisi per tutta la lega.',
  },
];

export default function HomePage() {
  return (
    <div className="flex flex-col">
      <HomeHero />
      <Separator />
      <HomeFeatures
        features={features}
        title="Tutto per la tua stagione"
        description="Le funzionalità della piattaforma, pronte da collegare ai dati reali della tua lega."
      />
      <Separator />
      <HomeCTA />
    </div>
  );
}
