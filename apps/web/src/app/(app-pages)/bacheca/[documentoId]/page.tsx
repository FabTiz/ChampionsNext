type PageProps = {
    params: Promise<{
        documentoId: string;
    }>;
};

export default async function DocumentoBachecaPage({ params }: PageProps) {
    const { documentoId } = await params;

    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Documento: {documentoId}</h1>
            <p className="text-sm text-muted-foreground">
                Viewer PDF inline, metadati documento, allegati e area commenti.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder viewer: iframe PDF + azione download.
            </div>
        </div>
    );
}
