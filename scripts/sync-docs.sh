#!/bin/bash
set -e

# Directory setup
DOCS_MODULES_DIR="docs/modules"
mkdir -p "$DOCS_MODULES_DIR"

# Clean existing modules to ensure no stale files
rm -f "$DOCS_MODULES_DIR"/*.md

echo "Syncing module documentation..."

# Index page for modules
cat > "$DOCS_MODULES_DIR/index.md" <<EOF
# Module Reference

This section contains detailed documentation for all available Terraform modules. Each page is automatically generated from the module's source code using \`terraform-docs\`.

## Available Modules

EOF

# Loop through all modules and copy READMEs
find modules -mindepth 2 -maxdepth 3 -name "README.md" | grep -vE "/scripts|/templates" | sort | while read -r readme; do
    module_path=$(dirname "$readme")
    module_name=$(basename "$module_path")
    
    # Handle nested modules (e.g., gravitino/server, kafka/cluster)
    # We replace slashes with hyphens for the filename
    safe_name=$(echo "$module_path" | sed 's|^modules/||' | sed 's|/|-|g')
    
    dest="$DOCS_MODULES_DIR/$safe_name.md"
    
    echo "  - $module_path -> $dest"
    cp "$readme" "$dest"
    
    # Add entry to the index page
    echo "- [$safe_name]($safe_name.md)" >> "$DOCS_MODULES_DIR/index.md"
done

echo "Done! Module documentation synced to $DOCS_MODULES_DIR"
