import { getUserPrivateItems } from '@/data/anon/privateItems';
import Link from 'next/link';
import { Suspense } from 'react';
import { DashboardHeading } from './dashboard-heading';
import { DashboardListSkeleton } from './dashboard-list-skeleton';
import { DashboardPrivateItemsSection } from './dashboard-private-items-section';

export default function DashboardPage() {
  const privateItemsPromise = getUserPrivateItems();
  return (
    <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
      <DashboardHeading />
      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <Link href="/leghe" className="rounded-lg border p-4 transition-colors hover:bg-muted/60">
          <p className="font-medium">Gestione leghe</p>
          <p className="text-xs text-muted-foreground">Crea e amministra competizioni fantacalcio</p>
        </Link>
        <Link href="/bacheca" className="rounded-lg border p-4 transition-colors hover:bg-muted/60">
          <p className="font-medium">Bacheca PDF</p>
          <p className="text-xs text-muted-foreground">Regolamenti e comunicazioni ufficiali</p>
        </Link>
        <Link href="/profilo" className="rounded-lg border p-4 transition-colors hover:bg-muted/60">
          <p className="font-medium">Profilo utente</p>
          <p className="text-xs text-muted-foreground">Impostazioni account e preferenze</p>
        </Link>
        <Link href="/admin/leghe" className="rounded-lg border p-4 transition-colors hover:bg-muted/60">
          <p className="font-medium">Area admin</p>
          <p className="text-xs text-muted-foreground">Controllo leghe e utenti</p>
        </Link>
      </div>
      <Suspense fallback={<DashboardListSkeleton />}>
        <DashboardPrivateItemsSection privateItemsPromise={privateItemsPromise} />
      </Suspense>
    </div>
  );
}
