export default function ProfiloPage() {
    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Profilo utente</h1>
            <p className="text-sm text-muted-foreground">
                Impostazioni account, avatar e preferenze personali.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: modifica nickname, avatar e notifiche.
            </div>
        </div>
    );
}
