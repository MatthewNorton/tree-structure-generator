#!/bin/bash

# Function to determine the depth based on the prefix of each line.
# Depth is determined by counting the number of vertical bars (either ASCII or Unicode).
get_depth() {
    local line="$1"
    local convention="$2"
    
    # Differentiate between ASCII and Unicode tree structures
    if [[ "$convention" == "unicode" ]]; then
        echo "$line" | sed -E 's/[^│]//g' | wc -c
    else
        echo "$line" | sed -E 's/[^|]//g' | wc -c
    fi
}

# Function to create folders and files based on tree structure from input file
create_structure() {
    local file="$1"
    local parent_dir="$2"
    local current_depth=0
    
    # Array to keep track of the path at each depth level
    local -a paths

    # Variable to hold the naming convention used in the tree (either 'ascii' or 'unicode')
    local naming_convention=""

    # Determine naming convention from the file
    if grep -q '├──' "$file"; then
        naming_convention="unicode"
    else
        naming_convention="ascii"
    fi

    # Flag to identify the first line (root folder)
    local first_line=true

    # Loop through each line in the file
    while IFS= read -r line; do
        # Special handling for the first line
        if [[ "$first_line" == "true" ]]; then
            # Remove trailing slash and set root folder
            paths[1]=$(echo "$line" | sed 's/\/$//')
            mkdir -p "$parent_dir/${paths[1]}"
            first_line=false
            continue
        fi

        # Get the depth of the current line
        local depth=$(get_depth "$line" "$naming_convention")

        # Extract the name of the folder or file from the current line
        local name=""
        if [[ "$naming_convention" == "unicode" ]]; then
            name=$(echo "$line" | sed -E 's/^[│ └├─]*//')
        else
            name=$(echo "$line" | sed -E 's/^[| -]*//')
        fi

        # Update paths based on the depth of the current line
        if (( $depth > $current_depth )); then
            paths[$((depth + 1))]="$name"
        elif (( $depth == $current_depth )); then
            paths[$((depth + 1))]="$name"
        else
            # Remove deeper paths when moving back up the tree
            for i in $(seq $((current_depth + 1)) -1 $((depth + 2))); do
                unset paths[$i]
            done
            paths[$((depth + 1))]="$name"
        fi

        # Update current depth
        current_depth=$depth

        # Generate the full path to the current folder or file
        local full_path=$(printf "/%s" "${paths[@]}")

        # Create the folder or file based on its type
        if [[ "$name" =~ /$ ]]; then
            mkdir -p "$parent_dir$full_path"
        elif [[ -n "$name" ]]; then
            touch "$parent_dir$full_path"
        fi

    done < "$file"
}

# Main program
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <path-to-tree-file> [parent-directory]"
    exit 1
fi

# Set default parent directory
PARENT_DIR="./"
# Override if a second argument is provided
if [[ $# -eq 2 ]]; then
    PARENT_DIR="$2"
fi

# Call function to create structure
create_structure "$1" "$PARENT_DIR"
