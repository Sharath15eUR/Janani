
                                                                              MODULE 3 ASSESSMENT 
                                                                             
                                                                              ~backup_manager.sh


#!/bin/bash
# Assigning  command-line arguments to variables
source_dir=$1
backup_dir=$2
extension=$3
# Checking  if source directory exists
if [[ ! -d "$source_dir" ]]; then
    echo "Source directory does not exist."
    exit 1
fi
# Create backup directory if it doesn't exist
if [[ ! -d "$backup_dir" ]]; then
    mkdir -p "$backup_dir" || { echo "Failed to create backup directory."; exit 1; }
fi
# Find files with the specified extension
files=("$source_dir"/*"$extension")

# Check if any files match the extension
if [[ ${#files[@]} -eq 0 ]]; then
    echo "No files with extension $extension found in source directory."
    exit 0
fi

# Export environment variable for backup count
export backup_count=0

# Starting  the backup process
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        # File name and size
      echo "Processing: $(basename "$file") - Size: $(ls -lh "$file" | awk '{print $5}')"
 
        # Check if the file exists in the backup directory
        DEST_FILE="$backup_dir/$(basename "$file")"
        if [[ ! -e "$DEST_FILE" || "$file" -nt "$DEST_FILE" ]]; then
            cp "$file" "$backup_dir"
            echo "Backed up: $(basename "$file")"
            ((backup_count++))
        else
            echo "Skipped : $(basename "$file")"
        fi
    fi
done
# Generate the backup report
REPORT_FILE="$backup_dir/backup_report.log"
{
    echo "Total files processed: $backup_count"
echo "Total size of files backed up: $(ls -lh "${files[@]}" | awk '{total+=$5} END {print total}')"
    echo "Backup directory: $backup_dir"
} > "$REPORT_FILE"

echo "Backup completed. Report saved to $REPORT_FILE"
