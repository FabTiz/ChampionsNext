type PageProps = {
    params: Promise<{
        legaId: string;
    }>;
};

export default async function LegaCalendarioPage({ params }: PageProps) {
    const { legaId } = await params;

    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Calendario - {legaId}</h1>
            <p className="text-sm text-muted-foreground">
                Generazione round-robin e gestione giornate della competizione.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: calendario partite, giornate, pubblicazione e lock risultati.
            </div>
        </div>
    );
}
