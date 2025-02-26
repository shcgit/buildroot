#!/bin/bash

# Generate empty environment
dd if=/dev/zero of=$BINARIES_DIR/barebox.env bs=1M count=1

# Generate image
support/scripts/genimage.sh -c board/milas/genimage.cfg

exit 0
