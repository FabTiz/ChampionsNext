import Link from 'next/link';

const demoDocumenti = [
    { id: 'regolamento-2026', titolo: 'Regolamento Stagione 2026/27', categoria: 'regolamento' },
    { id: 'comunicato-asta', titolo: 'Comunicato ufficiale asta iniziale', categoria: 'comunicazione' },
];

export default function BachecaPage() {
    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <div>
                <h1 className="text-2xl font-semibold tracking-tight">Bacheca documenti</h1>
                <p className="text-sm text-muted-foreground">
                    Regolamenti, comunicazioni e PDF condivisi a livello globale o per lega.
                </p>
            </div>

            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder upload: drag and drop PDF, categoria, visibilita globale/lega.
            </div>

            <div className="grid gap-3">
                {demoDocumenti.map((documento) => (
                    <Link
                        key={documento.id}
                        href={`/bacheca/${documento.id}`}
                        className="rounded-lg border p-4 transition-colors hover:bg-muted/60"
                    >
                        <p className="font-medium">{documento.titolo}</p>
                        <p className="text-xs text-muted-foreground">Categoria: {documento.categoria}</p>
                    </Link>
                ))}
            </div>
        </div>
    );
}
