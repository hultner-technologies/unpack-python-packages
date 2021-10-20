#!/usr/bin/env zsh 
# Python Wheel Bundler
# WARNING: DO NOT USE FOR PRODUCTION, NAIVE IMPLEMENTATION
# This bundler was hacked together in an hour for PyCon SE 2021
# and is mainly meant to showcase how simple the wheel format is.

export PACKAGE_DIR="${1?Target package required}"
# We could get this from the METADATA file, hardcoded for simplicity
export DISTRIBUTION="$PACKAGE_DIR"
export VERSION="0.1.0"
export INFO_DIR="$PACKAGE_DIR-$VERSION.dist-info"
# "python tag"-"abi tag"-"platform tag"
export TAG="py3-none-any"
export WHEEL_FILE="dist/$DISTRIBUTION-$VERSION-$TAG.whl"
echo "Creating wheel for: $PACKAGE_DIR"
echo "Target: $WHEEL_FILE"
# Setup dist folder
mkdir dist 2>/dev/null
# Remove old wheel file if it exists
rm "$WHEEL_FILE" 2>/dev/null
# Remove old RECORD
rm "$INFO_DIR/RECORD" 2>/dev/null

# Create a Record file
shasum -a256 {"$PACKAGE_DIR","$INFO_DIR"}/** \
| while read hex; do 
    # Output the filename and hash algo
    printf $(printf $hex|awk '{print $2}'),sha256=
    # Output the hash in base64 encoded bytes
    printf $hex | 
        # Get the hash, discard filename
        awk '{print $1}' | 
        # Convert the hex hash to bytes, reverse plain
        xxd -r -p |
        # B64 encode the bytes
        base64 |
        # Remove trailing =
        sed 's/.$//' |
        # Remove newline
        tr -d '\n'; 
    # Output file sizes
    echo ,$(printf $hex |
        # Get the filename
        awk '{print $2}' |
        # Count file size
        xargs cat |
        wc -c |
        # Remove white-space
        awk '{print $1}'
    )
done |
    # Write to RECORD using sponge to exclude RECORD from signatures
    # as the record can't contain it's own hash.
    sponge $INFO_DIR/RECORD

# Set up a RECORD for the RECORD file, this is excluded from hashing
echo  "$INFO_DIR/RECORD,," >> $INFO_DIR/RECORD

# Create wheel
# zip relevant directories recursively.
# It's recommended to put dist-info at the end, so
# metadata can be amended without full rewrite.
zip -r $WHEEL_FILE $PACKAGE_DIR $INFO_DIR 

echo -e "\nWheel built succesfully:"
echo "$WHEEL_FILE"
