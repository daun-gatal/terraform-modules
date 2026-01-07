import { defineConfig } from 'vitepress'
import sidebar from './data/sidebar.json'

export default defineConfig({
    base: '/terraform-modules/',
    title: "Terraform Modules",
    description: "Production-grade Terraform modules for data platforms.",
    head: [
        ['link', { rel: 'preconnect', href: 'https://fonts.googleapis.com' }],
        ['link', { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' }],
        ['link', { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap' }],
        ['link', { rel: 'icon', href: '/favicon.ico' }]
    ],
    themeConfig: {
        nav: [
            { text: 'Overview', link: '/' },
            { text: 'Module Details', link: '/modules/' },
            { text: 'Example of Usage', link: '/examples' }
        ],

        sidebar: sidebar,

        socialLinks: [
            { icon: 'github', link: 'https://github.com/daun-gatal/terraform-modules' },
            { icon: 'linkedin', link: 'https://linkedin.com/in/rizal-mahifa' }
        ],

        footer: {
            message: 'Released under the MIT License.',
            copyright: 'Copyright © 2025 Rizal M.'
        },

        search: {
            provider: 'local'
        }
    },
    appearance: 'dark',
})
