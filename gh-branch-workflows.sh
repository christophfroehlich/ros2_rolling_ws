#!/bin/bash

# Usage check
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <old_string> <new_string>"
    exit 1
fi

OLD_STR="$1"
NEW_STR="$2"
DIR="."

# Function to get different case variants
capitalize() {
    # Capitalize first letter
    echo "${1^}"
}

uppercase() {
    # Uppercase all letters
    echo "${1^^}"
}

lowercase() {
    # Lowercase all letters
    echo "${1,,}"
}

# Case variants
OLD_LOWER=$(lowercase "$OLD_STR")
OLD_CAP=$(capitalize "$OLD_STR")
OLD_UPPER=$(uppercase "$OLD_STR")

NEW_LOWER=$(lowercase "$NEW_STR")
NEW_CAP=$(capitalize "$NEW_STR")
NEW_UPPER=$(uppercase "$NEW_STR")

# Loop through all files starting with any variant
for file in "$DIR"/*; do
    [ -e "$file" ] || continue

    filename=$(basename "$file")
    dirname=$(dirname "$file")
    new_filename="$filename"

    # Replace old variants in filename
    new_filename="${new_filename//$OLD_LOWER/$NEW_LOWER}"
    new_filename="${new_filename//$OLD_CAP/$NEW_CAP}"
    new_filename="${new_filename//$OLD_UPPER/$NEW_UPPER}"

    new_file="$dirname/$new_filename"

    # Copy file if renamed
    if [ "$file" != "$new_file" ]; then
        cp "$file" "$new_file"
    else
        # Just copy as-is
        cp "$file" "$new_file"
    fi

    # Replace variants inside the file content
    sed -i "s/$OLD_LOWER/$NEW_LOWER/g; s/$OLD_CAP/$NEW_CAP/g; s/$OLD_UPPER/$NEW_UPPER/g" "$new_file"

    echo "Processed $file -> $new_file"
done
