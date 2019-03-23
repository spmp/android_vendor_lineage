#!/bin/bash

WIDTH="$1"
HEIGHT="$2"
HALF_RES="$3"
OUT="$ANDROID_PRODUCT_OUT/obj/BOOTANIMATION"

# If `zip` file is present use it
if [[ -f "vendor/lineage/bootanimation/bootanimation.zip" ]]; then
  cp -a "vendor/lineage/bootanimation/bootanimation.zip" "$OUT/bootanimation.zip"
  exit 0
fi

# Ensure orientation is correct
if [ "$HEIGHT" -lt "$WIDTH" ]; then
    IMAGEWIDTH="$HEIGHT"
    IMAGEHEIGHT="$WIDTH"
else
    IMAGEWIDTH="$WIDTH"
    IMAGEHEIGHT="$HEIGHT"
fi

# Set resolution
RESOLUTION=""$IMAGEWIDTH"x"$IMAGEHEIGHT""


# Check output directory exists
if [[ ! -d "$OUT/bootanimation" ]]; then
  echo "ERROR! Bootanimation output directory does not exist"
  exit 1
fi
# Clean bootanimation dir
rm -rf "$OUT/bootanimation/*"
# Extract `tar` file
tar xfp "vendor/lineage/bootanimation/bootanimation.tar" -C "$OUT/bootanimation/"

if [[ ! -f "$OUT/bootanimation/desc.txt" ]]; then
  echo "ERROR! 'desc.txt' missing from 'vendor/lineage/bootanimation/bootanimation.tar'"
  exit 1
fi

# Resize files
mogrify -resize $RESOLUTION -colors 250 "$OUT/bootanimation/part"*"/"*".png"

# *replace resolution in first line of desc.txt with correct resolution
sed -i -r "s/^[0-9]+ [0-9]+/$IMAGEWIDTH $IMAGEHEIGHT/" "$OUT/bootanimation/desc.txt"

# Create bootanimation.zip
cd "$OUT/bootanimation"

zip -qr0 "$OUT/bootanimation.zip" .
