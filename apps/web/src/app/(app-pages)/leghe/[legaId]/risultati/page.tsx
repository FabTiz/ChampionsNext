type PageProps = {
    params: Promise<{
        legaId: string;
    }>;
};

export default async function LegaRisultatiPage({ params }: PageProps) {
    const { legaId } = await params;

    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Risultati - {legaId}</h1>
            <p className="text-sm text-muted-foreground">
                Inserimento voti e calcolo punteggi per ogni giornata.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: tabella risultati, bonus/malus e conferma ufficiale giornata.
            </div>
        </div>
    );
}
