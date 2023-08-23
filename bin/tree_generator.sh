#!/bin/bash

# Function to determine depth based on the prefix
get_depth() {
    local line="$1"
    echo "$line" | sed -E 's/[^|]//g' | wc -c
}

# Create folders and files based on tree structure from input file
create_structure() {
    local file="$1"
    local current_depth=0
    local -a paths

    while IFS= read -r line; do
        local depth=$(get_depth "$line")
        local name=$(echo "$line" | sed -E 's/[| ]*|-- //g')

        if (( $depth > $current_depth )); then
            paths[$depth]="$name"
        elif (( $depth == $current_depth )); then
            paths[$depth]="$name"
        else
            for i in $(seq $current_depth -1 $depth); do
                unset paths[$i]
            done
            paths[$depth]="$name"
        fi

        current_depth=$depth
        local full_path=$(printf "/%s" "${paths[@]}")

        if echo "$name" | grep -q '/$'; then
            mkdir -p ".$full_path"
        else
            touch ".$full_path"
        fi

    done < "$file"
}

# Main
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path-to-tree-file>"
    exit 1
fi

create_structure "$1"
