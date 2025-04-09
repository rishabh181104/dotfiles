#!/bin/bash

# Create output directory
mkdir -p converted_jpgs

# Process all MP4 files
find . -type f -iname "*.mp4" | while IFS= read -r video_file; do
echo "Processing: $video_file"

    # Extract filename without extension
    base_name=$(basename "$video_file" .mp4)

    # Convert to highest quality JPG (1 frame per second)
    ffmpeg -i "$video_file" \
	    -q:v 2 \
	    -vf "fps=1" \
	    "converted_jpgs/${base_name}_%04d.jpg" || {
	    echo "Error processing $video_file"
		continue
	}

	echo "Converted: $video_file → converted_jpgs/${base_name}_*.jpg"
done

echo "All conversions complete!"

