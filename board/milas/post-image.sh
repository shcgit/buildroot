#!/bin/bash

set -euo pipefail

if [[ -z "${BINARIES_DIR:-}" ]]; then
	echo "ERROR: BINARIES_DIR environment variable not set" >&2
	exit 1
fi

script_path="$0"
resolved_script_path=$(realpath "$script_path")
BOARD_DIR=$(dirname "$resolved_script_path")

env_file="${BINARIES_DIR}/barebox.env"
if [[ ! -f "$env_file" ]]; then
	echo "Creating barebox environment file..."
	if ! dd if=/dev/zero of="$env_file" bs=1M count=1 status=progress; then
		echo "ERROR: Failed to create barebox environment file" >&2
		exit 1
	fi
	sync

	if [[ ! -f "$env_file" ]]; then
		echo "ERROR: barebox.env was not created" >&2
		exit 1
	fi

	if [[ $(stat -c %s "$env_file") -ne 1048576 ]]; then
		echo "ERROR: barebox.env has incorrect size" >&2
		exit 1
	fi
	echo "Successfully created barebox environment: ${env_file}"
else
	echo "Using existing barebox environment: ${env_file}"
fi

echo "Starting image generation process..."
config_file="${BOARD_DIR}/genimage.cfg"

if [[ ! -f "$config_file" ]]; then
	echo "ERROR: genimage configuration not found: ${config_file}" >&2
	exit 1
fi

echo "Generating system image with config: ${config_file}"
if support/scripts/genimage.sh -c "$config_file"; then
	echo "Image generated successfully"
else
	exit_code=$?
	echo "ERROR: Image generation failed with exit code ${exit_code}" >&2
	exit $exit_code
fi
