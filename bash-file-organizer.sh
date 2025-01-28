#!/bin/bash

# Prompt the user to enter the path to the original directory
read -p "Please enter the path to the original directory: " DIR

# Change to the specified directory
cd "$DIR" || { echo "I couldn't find that directory. I give up! Exiting."; exit 1; }

# Loop through each file in the directory
for FILE in *; do
  # Check if it is a regular file
  if [[ -f "$FILE" ]]; then
    # Extract the identifier from the file name (e.g., prefix before an underscore)
    IDENTIFIER=$(echo "$FILE" | cut -d'_' -f1)
    
    # Create a directory with the identifier if it doesn't exist
    mkdir -p "$IDENTIFIER"
    
    # Move the file to the corresponding directory
    mv "$FILE" "$IDENTIFIER/"
  fi
done

echo "Yay! The files are now organized into directories!"