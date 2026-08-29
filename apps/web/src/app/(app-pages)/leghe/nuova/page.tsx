export default function NuovaLegaPage() {
    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Crea una nuova lega</h1>
            <p className="max-w-2xl text-sm text-muted-foreground">
                Qui collegherai il form reale con Supabase per configurare nome lega, stagione, numero squadre e regolamento PDF.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder form: nome, descrizione, date, max squadre, upload regolamento.
            </div>
        </div>
    );
}
