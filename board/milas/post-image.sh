#!/bin/bash

# Generate empty environment
dd if=/dev/zero of=$BINARIES_DIR/barebox.env bs=1M count=1

# Generate image
BOARD_DIR="$(dirname $0)"
support/scripts/genimage.sh -c $BOARD_DIR/genimage.cfg

exit 0
