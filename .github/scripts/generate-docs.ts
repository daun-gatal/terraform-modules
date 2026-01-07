import { file, write } from 'bun';
import { mkdir } from 'node:fs/promises';
import { join } from 'node:path';
import inventory from './docs-inventory.json';

const SOURCE_DIR = 'modules';
const DOCS_DIR = 'docs/modules';
const DATA_DIR = 'docs/.vitepress/data';

console.log('🔄 Starting Documentation Sync...');

// Prepare Data Structures
const sidebar = [];
const explorerModules = [];

// Ensure Directories Exist
await mkdir(DATA_DIR, { recursive: true });

// 1. Copy Inventory to Data Dir (for ModuleExplorer to consume safely)
console.log('📦 Publishing Inventory...');
await write(join(DATA_DIR, 'inventory.json'), JSON.stringify(inventory, null, 2));

for (const [group, modules] of Object.entries(inventory)) {
    console.log(`📂 Processing Group: ${group}`);

    // Create Group Directory in Docs
    const groupSlug = group.toLowerCase().replace(/\s+/g, '-');
    const groupDir = join(DOCS_DIR, groupSlug);
    await mkdir(groupDir, { recursive: true });

    const sidebarGroup = {
        text: group,
        items: []
    };

    for (const mod of modules) {
        console.log(`   🔸 Syncing Module: ${mod.name} (${mod.source})`);

        // Define Paths
        // Note: For unified modules like Kafka/ClickHouse, the documentation exists in docs/modules/... 
        // effectively detached from source README since we have custom tabs.
        // CHECK: If a custom file exists in docs/modules/GROUP/NAME.md, DO NOT overwrite it with README.
        // Only verify it exists.

        const docFileName = `${mod.source}.md`;
        const docFilePath = join(groupDir, docFileName);
        const linkPath = `/modules/${groupSlug}/${mod.source}`;

        // Add to Sidebar
        sidebarGroup.items.push({ text: mod.name, link: linkPath });

        // Add to Explorer Data
        explorerModules.push({
            name: mod.name,
            category: group,
            icon: mod.icon || getIcon(group), // Allow overlap
            desc: mod.desc,
            link: linkPath
        });

        // Copy README logic?
        // Current state: I have MANUALLY created heavily customized files (tabs).
        // If I overwrite them with raw READMEs, I lose the tabs.
        // STRATEGY: 
        // 1. Check if the destination MD file exists.
        // 2. If it DOES NOT exist, copy source README.
        // 3. If it DOES exist, leave it alone (manual override/customization wins).

        const sourceReadme = join(SOURCE_DIR, mod.source, 'README.md');
        const fileExists = await file(docFilePath).exists();

        if (!fileExists) {
            console.log(`      Creating new doc from ${sourceReadme}`);
            const readmeFile = file(sourceReadme);
            if (await readmeFile.exists()) {
                const content = await readmeFile.text();
                // Add Frontmatter or Title if missing?
                await write(docFilePath, `# ${mod.name}\n\n${content}`);
            } else {
                console.warn(`      ⚠️  WARNING: Source README not found for ${mod.source}`);
                await write(docFilePath, `# ${mod.name}\n\nDocumentation coming soon.`);
            }
        } else {
            console.log(`      ✅ Preserving existing doc: ${docFilePath}`);
        }
    }

    sidebar.push(sidebarGroup);
}

// Write Generated Data
console.log('💾 Writing Generated Configs...');
await write(join(DATA_DIR, 'sidebar.json'), JSON.stringify(sidebar, null, 2));
await write(join(DATA_DIR, 'modules.json'), JSON.stringify(explorerModules, null, 2));

console.log('✨ Documentation Sync Complete!');

function getIcon(category) {
    const map = {
        'Metadata': '🌌',
        'Storage': '🪣',
        'Streaming': '📨',
        'Analytics': '📊',
        'Orchestration': '🌩️',
        'Identity': '🔐',
        'Ingestion': '📥',
        'Query Engines': '⚡',
        'Infrastructure': '🐘'
    };
    return map[category] || '📦';
}
