//https://nitro.unjs.io/config
export default defineNitroConfig({
    preset: 'vercel_edge',
    vercel: {
        regions: ["pdx1"， "cle1", "iad1", "sfo1"]
    },
    routeRules: {
        '/google/**': {
            proxy: 'https://generativelanguage.googleapis.com/:splat'
        },
        '/openai/**': {
            proxy: 'https://api.openai.com/:splat'
        }
    }
});
