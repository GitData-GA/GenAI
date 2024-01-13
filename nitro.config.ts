//https://nitro.unjs.io/config
export default defineNitroConfig({
    preset: 'vercel_edge',
    vercel: {
        regions: ["cle1", "iad1", "sfo1", "pdx1"]
    },
    routeRules: {
        '/google/**': {
            proxy: 'https://generativelanguage.googleapis.com/**'
        },
        '/openai/**': {
            proxy: 'https://api.openai.com/**'
        }
    }
});
