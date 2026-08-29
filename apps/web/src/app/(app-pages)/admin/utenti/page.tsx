export default function AdminUtentiPage() {
    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Admin - Utenti</h1>
            <p className="text-sm text-muted-foreground">
                Gestione ruoli globali, abilitazioni e moderazione utenti.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: ricerca utenti, promozione admin/gestore, sospensione account.
            </div>
        </div>
    );
}
