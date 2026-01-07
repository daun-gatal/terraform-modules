/// <reference types="vite/client" />

declare module '*.vue' {
    import type { DefineComponent } from 'vue'
    const component: DefineComponent<{}, {}, any>
    export default component
}

declare module 'vitepress/theme' {
    const theme: {
        Layout: any
        enhanceApp: (ctx: any) => void
        extends?: any
    }
    export default theme
}
