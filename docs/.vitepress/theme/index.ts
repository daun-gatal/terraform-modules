import DefaultTheme from 'vitepress/theme'
import ModuleExplorer from '../components/ModuleExplorer.vue'
import './style.css'

export default {
    extends: DefaultTheme,
    enhanceApp({ app }: { app: any }) {
        app.component('ModuleExplorer', ModuleExplorer)
    }
}
