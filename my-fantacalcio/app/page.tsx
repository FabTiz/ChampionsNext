export default function Home() {
  return (
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <main className="mx-auto flex w-full max-w-6xl flex-col gap-8 px-6 py-10 md:px-10">
        <header className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
          <p className="text-sm font-semibold uppercase tracking-widest text-emerald-700">
            My Fantacalcio
          </p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight md:text-4xl">
            Schermata principale
          </h1>
          <p className="mt-3 max-w-3xl text-slate-600">
            Questa e una base pronta da adattare: qui puoi collegare dati reali,
            autenticazione e dashboard delle tue leghe.
          </p>
        </header>

        <section className="grid gap-4 md:grid-cols-3">
          <article className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <h2 className="text-lg font-semibold">Le tue leghe</h2>
            <p className="mt-2 text-sm text-slate-600">
              Elenco leghe attive, classifica rapida e accesso ai dettagli.
            </p>
          </article>
          <article className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <h2 className="text-lg font-semibold">Giornata corrente</h2>
            <p className="mt-2 text-sm text-slate-600">
              Risultati live, stato formazione e punteggi in aggiornamento.
            </p>
          </article>
          <article className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <h2 className="text-lg font-semibold">Mercato</h2>
            <p className="mt-2 text-sm text-slate-600">
              Offerte aperte, storico scambi e suggerimenti per la rosa.
            </p>
          </article>
        </section>

        <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
          <h2 className="text-xl font-semibold">Prossimi passi</h2>
          <ul className="mt-4 grid gap-3 text-sm text-slate-700 md:grid-cols-2">
            <li className="rounded-lg border border-slate-200 p-3">
              1. Collega la lista leghe da API o database.
            </li>
            <li className="rounded-lg border border-slate-200 p-3">
              2. Aggiungi il layout con sidebar e navigazione.
            </li>
            <li className="rounded-lg border border-slate-200 p-3">
              3. Inserisci autenticazione utente.
            </li>
            <li className="rounded-lg border border-slate-200 p-3">
              4. Porta i componenti in cartelle riusabili.
            </li>
          </ul>
        </section>
      </main>
    </div>
  );
}
