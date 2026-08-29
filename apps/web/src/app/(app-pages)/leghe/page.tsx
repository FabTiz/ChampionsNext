import Link from 'next/link';

const demoLeghe = [
    { id: 'serie-a-2026', nome: 'Serie A Friends 2026/27', stato: 'Bozza' },
    { id: 'ufficio-premium', nome: 'Lega Ufficio Premium', stato: 'Attiva' },
];

export default function LeghePage() {
    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-semibold tracking-tight">Le mie leghe</h1>
                    <p className="text-sm text-muted-foreground">
                        Crea e gestisci le competizioni fantacalcio della tua stagione.
                    </p>
                </div>
                <Link
                    href="/leghe/nuova"
                    className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground"
                >
                    Nuova lega
                </Link>
            </div>

            <div className="grid gap-3">
                {demoLeghe.map((lega) => (
                    <Link
                        key={lega.id}
                        href={`/leghe/${lega.id}`}
                        className="rounded-lg border p-4 transition-colors hover:bg-muted/60"
                    >
                        <p className="font-medium">{lega.nome}</p>
                        <p className="text-xs text-muted-foreground">Stato: {lega.stato}</p>
                    </Link>
                ))}
            </div>
        </div>
    );
}
