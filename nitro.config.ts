//https://nitro.unjs.io/config
export default defineNitroConfig({
    preset: 'vercel_edge',
    vercel: {
        regions: ["cle1", "iad1", "sfo1", "pdx1", "hnd1", "icn1", "sin1", "kix1"]
    },
    routeRules: {
        '/': {
            redirect: 'https://genai.gd.edu.kg/api/'
        },
        '/google/**': {
            proxy: 'https://generativelanguage.googleapis.com/**'
        },
        '/openai/**': {
            proxy: 'https://api.openai.com/**'
        },
        '/moonshot/**': {
            proxy: 'https://api.moonshot.cn/**'
        }
    }
});
