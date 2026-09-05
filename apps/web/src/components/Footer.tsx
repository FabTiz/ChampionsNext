import { Separator } from '@/components/ui/separator';
import { T } from '@/components/ui/Typography';
import { Trophy } from 'lucide-react';
import Link from 'next/link';

const Footer = () => {
  return (
    <footer className="bg-muted/50 py-8 sm:py-12">
      <div className="container mx-auto px-4 md:px-6">
        <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-4 pb-12 md:pb-16">
          <div className="space-y-4">
            <Link href="/" className="flex items-center gap-2">
              <Trophy className="h-6 w-6 text-primary" />
              <T.H3 className="text-xl">My Fantacalcio</T.H3>
            </Link>
            <T.P className="text-sm text-muted-foreground">
              La piattaforma per gestire le tue leghe di fantacalcio:
              classifiche, giornate, mercato e bacheca in un unico posto.
            </T.P>
          </div>

          <div className="space-y-4">
            <T.H4 className="text-sm font-semibold uppercase">Piattaforma</T.H4>
            <nav className="flex flex-col space-y-2.5">
              <Link
                href="/leghe"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Le tue leghe
              </Link>
              <Link
                href="/bacheca"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Bacheca
              </Link>
              <Link
                href="/dashboard"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Dashboard
              </Link>
            </nav>
          </div>

          <div className="space-y-4">
            <T.H4 className="text-sm font-semibold uppercase">Account</T.H4>
            <nav className="flex flex-col space-y-2.5">
              <Link
                href="/login"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Accedi
              </Link>
              <Link
                href="/sign-up"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Registrati
              </Link>
              <Link
                href="/profilo"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Profilo
              </Link>
            </nav>
          </div>

          <div className="space-y-4">
            <T.H4 className="text-sm font-semibold uppercase">Risorse</T.H4>
            <nav className="flex flex-col space-y-2.5">
              <Link
                href="/about"
                className="text-sm text-muted-foreground hover:text-foreground transition-colors"
              >
                Chi siamo
              </Link>
            </nav>
          </div>
        </div>

        <Separator className="my-6 lg:my-8" />

        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <T.Small className="text-muted-foreground">
            © 2026 My Fantacalcio. Tutti i diritti riservati.
          </T.Small>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
