/** @type {import('next-sitemap').IConfig} */
function getSiteUrl() {
  // Order matters: an explicit override wins, then Vercel's own domain
  // variables, and only as a last resort a local URL.
  //
  // `VERCEL_PROJECT_PRODUCTION_URL` is preferred over `VERCEL_URL` because it
  // points at the stable production domain, not at the individual deployment
  // (which is what a sitemap should advertise). Both are injected by Vercel at
  // build time and require "System Environment Variables" to be enabled.
  const siteUrl =
    process.env.NEXT_PUBLIC_SITE_URL ??
    process.env.VERCEL_PROJECT_PRODUCTION_URL ??
    process.env.VERCEL_URL ??
    'http://localhost:3000';

  return siteUrl.startsWith('http') ? siteUrl : `https://${siteUrl}`;
}

module.exports = {
  siteUrl: getSiteUrl(),
  generateRobotsTxt: true,
};
