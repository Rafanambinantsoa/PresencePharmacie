// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    modules: [
        '@nuxtjs/color-mode',
        '@nuxt/image',
        '@pinia/nuxt',
        'nuxt-icon',
        '@vueuse/nuxt',
        'nuxt-headlessui',
        '@morev/vue-transitions/nuxt'
    ],
  headlessui: { prefix: "H" },
    css:[
        '~/assets/css/app.css',
    ],
    colorMode:{
        preference: 'system', // default value of $colorMode.preference
        fallback: 'dark', // fallback value if not system preference found
        hid: 'nuxt-color-mode-script',
        globalName: '__NUXT_COLOR_MODE__',
        componentName: 'ColorScheme',
        classPrefix: '',
        classSuffix: '',
        storageKey: 'nuxt-color-mode'
    },
    postcss:{
        plugins: {
            tailwindcss: {},
            autoprefixer: {}
        }
    },
})
