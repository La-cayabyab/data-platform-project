#!/bin/bash

# Change to infrastructure directory
cd "$CLEANUP_PATH"

# Check if any backup files exist (including numbered backups)
if ls terraform.tfstate*.backup 1> /dev/null 2>&1; then
    # Keep track of initial count
    initial_count=$(ls terraform.tfstate*.backup | wc -l)
    echo "Found $initial_count backup files"
    
    # List files before cleanup
    echo "Files to clean up:"
    ls -la terraform.tfstate*.backup
    
    # Keep only the most recent backup, removing all others
    ls -t terraform.tfstate*.backup | tail -n +2 | xargs rm -v
    
    # Report results
    remaining=$(ls terraform.tfstate*.backup | wc -l)
    removed=$((initial_count - remaining))
    echo -e "\nRemoved $removed old tfstate backup(s)"
    echo "Kept most recent backup: $(ls terraform.tfstate*.backup)"
else
    echo "No tfstate backup files found"
fi