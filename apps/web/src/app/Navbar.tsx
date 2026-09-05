import { Button } from '@/components/ui/button';
import { ModeToggle } from '@/components/ui/mode-toggle';
import { Trophy } from 'lucide-react';
import Link from 'next/link';

export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-14 max-w-screen-2xl items-center mx-auto px-4">
        <div className="flex items-center gap-6 flex-1">
          <Link href="/" className="flex items-center gap-2 font-bold text-lg">
            <Trophy className="h-5 w-5 text-primary" />
            <span className="text-primary">My Fantacalcio</span>
          </Link>
          <nav className="hidden md:flex items-center gap-6 text-sm">
            <Link href="/leghe" className="text-muted-foreground transition-colors hover:text-foreground">
              Le tue leghe
            </Link>
            <Link href="/bacheca" className="text-muted-foreground transition-colors hover:text-foreground">
              Bacheca
            </Link>
          </nav>
        </div>
        <div className="flex items-center gap-2">
          <ModeToggle />
          <Button asChild variant="ghost" size="sm">
            <Link href="/login">Accedi</Link>
          </Button>
          <Button asChild size="sm">
            <Link href="/sign-up">Registrati</Link>
          </Button>
        </div>
      </div>
    </header>
  );
}
