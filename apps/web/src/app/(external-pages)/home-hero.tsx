'use client';

import BlurText from '@/components/BlurText';
import ShinyText from '@/components/ShinyText';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { ArrowRight, Trophy } from 'lucide-react';
import Link from 'next/link';

export function HomeHero() {
  return (
    <section className="flex flex-col items-center justify-center gap-6 py-24 px-4 text-center">
      <Badge variant="secondary" className="px-3 py-1">
        <Trophy className="mr-1 h-3.5 w-3.5" /> My Fantacalcio
      </Badge>
      <h1 className="text-4xl font-bold tracking-tight sm:text-6xl max-w-3xl">
        <ShinyText
          text="Gestisci le tue leghe di fantacalcio"
          className="font-bold"
          color="var(--foreground)"
          shineColor="var(--primary)"
        />
      </h1>
      <BlurText
        text="Classifiche, giornate, mercato e bacheca per la tua lega: tutto in un unico posto, semplice e veloce."
        className="text-muted-foreground text-lg max-w-xl justify-center"
        delay={30}
        animateBy="words"
      />
      <div className="flex flex-wrap gap-3 justify-center">
        <Button asChild size="lg">
          <Link href="/sign-up">
            Crea la tua lega <ArrowRight className="ml-2 h-4 w-4" />
          </Link>
        </Button>
        <Button asChild size="lg" variant="outline">
          <Link href="/login">
            Accedi alla tua area
          </Link>
        </Button>
      </div>
    </section>
  );
}
