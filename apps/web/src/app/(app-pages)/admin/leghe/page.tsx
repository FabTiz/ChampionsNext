export default function AdminLeghePage() {
    return (
        <div className="flex flex-1 flex-col gap-4 p-4 md:p-6">
            <h1 className="text-2xl font-semibold tracking-tight">Admin - Leghe</h1>
            <p className="text-sm text-muted-foreground">
                Supervisione completa delle leghe e interventi amministrativi.
            </p>
            <div className="rounded-lg border border-dashed p-6 text-sm text-muted-foreground">
                Placeholder: elenco leghe, audit modifiche, blocco/riattivazione competizioni.
            </div>
        </div>
    );
}
