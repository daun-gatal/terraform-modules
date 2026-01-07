import { defineConfig } from 'vitepress'
import sidebar from './data/sidebar.json'

export default defineConfig({
    title: "Terraform Modules",
    // ...
    themeConfig: {
        // ...
        sidebar: sidebar,
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

            sidebar: [
                {
                    text: 'Orchestration',
                    items: [
                        { text: 'Airflow', link: '/modules/orchestration/airflow' },
                        { text: 'Kestra', link: '/modules/orchestration/kestra' },
                        { text: 'Dockge', link: '/modules/orchestration/dockge' }
                    ]
                },
                {
                    text: 'Analytics',
                    items: [
                        { text: 'Superset', link: '/modules/analytics/superset' },
                        { text: 'Metabase', link: '/modules/analytics/metabase' },
                        { text: 'ClickHouse', link: '/modules/analytics/clickhouse' }
                    ]
                },
                {
                    text: 'Streaming',
                    items: [
                        { text: 'Kafka Ecosystem', link: '/modules/streaming/kafka' }
                    ]
                },
                {
                    text: 'Storage',
                    items: [
                        { text: 'MinIO', link: '/modules/storage/minio' },
                        { text: 'RustFS', link: '/modules/storage/rustfs' }
                    ]
                },
                {
                    text: 'Metadata',
                    items: [
                        { text: 'Gravitino', link: '/modules/metadata/gravitino' },
                        { text: 'HMS', link: '/modules/metadata/hms' },
                        { text: 'Lakekeeper', link: '/modules/metadata/lakekeeper' },
                        { text: 'Nessie', link: '/modules/metadata/nessie' }
                    ]
                },
                {
                    text: 'Query Engines',
                    items: [
                        { text: 'Trino', link: '/modules/query-engines/trino' }
                    ]
                },
                {
                    text: 'Identity',
                    items: [
                        { text: 'Keycloak', link: '/modules/identity/keycloak' },
                        { text: 'OpenBao', link: '/modules/identity/openbao' }
                    ]
                },
                {
                    text: 'Infrastructure',
                    items: [
                        { text: 'Postgres', link: '/modules/infrastructure/postgres' }
                    ]
                },
                {
                    text: 'Ingestion',
                    items: [
                        { text: 'Airbyte', link: '/modules/ingestion/airbyte' }
                    ]
                }
            ],

            socialLinks: [
                { icon: 'github', link: 'https://github.com/daun-gatal/terraform-modules' },
                { icon: 'linkedin', link: 'https://linkedin.com/in/rizal-mahifa' }
            ],

            footer: {
                message: 'Released under the MIT License.',
                copyright: 'Copyright © 2025 Rizal M.'
            },

            // Search provider
            search: {
                provider: 'local'
            }
        },
        appearance: 'dark', // Default to dark mode if preferred, or remove for system default
    }
})
