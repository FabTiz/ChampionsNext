import Link from 'next/link';

type PageProps = {
    params: Promise<{
        legaId: string;
    }>;
};

const tabs = [
    { href: 'squadre', label: 'Squadre' },
    { href: 'calendario', label: 'Calendario' },
    { href: 'risultati', label: 'Risultati' },
    { href: 'classifica', label: 'Classifica' },
];

export default async function LegaDettaglioPage({ params }: PageProps) {
    const { legaId } = await params;

    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Dettaglio lega: {legaId}</h1>
            <p className="text-sm text-muted-foreground">
                Panoramica generale della lega con accesso rapido alle sezioni operative.
            </p>

            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
                {tabs.map((tab) => (
                    <Link
                        key={tab.href}
                        href={`/leghe/${legaId}/${tab.href}`}
                        className="rounded-lg border p-4 transition-colors hover:bg-muted/60"
                    >
                        <p className="font-medium">{tab.label}</p>
                        <p className="text-xs text-muted-foreground">Apri sezione {tab.label.toLowerCase()}</p>
                    </Link>
                ))}
            </div>
        </div>
    );
}
