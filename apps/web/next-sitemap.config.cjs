/** @type {import('next-sitemap').IConfig} */

// The generated files are committed under `public/`, so the URL must not depend
// on whatever environment happens to run the build. A plain `localhost` default
// meant that building locally overwrote the committed files with unreachable
// URLs, and those stale files are what ended up being served in production.
//
// An explicit override wins, then Vercel's own production domain (so custom
// domains are picked up automatically), and finally the real deployed domain.
function getSiteUrl() {
  const siteUrl =
    process.env.NEXT_PUBLIC_SITE_URL ??
    process.env.VERCEL_PROJECT_PRODUCTION_URL ??
    'championsnext-web.vercel.app';

  return siteUrl.startsWith('http') ? siteUrl : `https://${siteUrl}`;
}

module.exports = {
  siteUrl: getSiteUrl(),
  generateRobotsTxt: true,
};
