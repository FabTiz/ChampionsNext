type PageProps = {
    params: Promise<{
        legaId: string;
    }>;
};

export default async function LegaSquadrePage({ params }: PageProps) {
    const { legaId } = await params;

    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Squadre - {legaId}</h1>
            <p className="text-sm text-muted-foreground">
                Gestione iscrizioni, proprietari e configurazione rose per la lega selezionata.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: lista squadre, inviti, stato iscrizione, azioni gestore lega.
            </div>
        </div>
    );
}
