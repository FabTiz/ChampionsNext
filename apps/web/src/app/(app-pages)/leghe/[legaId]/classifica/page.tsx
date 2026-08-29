type PageProps = {
    params: Promise<{
        legaId: string;
    }>;
};

export default async function LegaClassificaPage({ params }: PageProps) {
    const { legaId } = await params;

    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Classifica - {legaId}</h1>
            <p className="text-sm text-muted-foreground">
                Ranking della lega con punti, vittorie, pareggi e differenza reti.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: classifica live, storico giornate, tie-break regolamentari.
            </div>
        </div>
    );
}
