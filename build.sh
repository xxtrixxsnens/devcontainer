#!/bin/bash
set -e

# Detect container engine (prefer podman)
if command -v podman &> /dev/null; then
    ENGINE="podman"
elif command -v docker &> /dev/null; then
    ENGINE="docker"
else
    echo "Error: Neither podman nor docker was found in PATH." >&2
    exit 1
fi

ALPINE_VERSION="3.20"

echo "Using container engine: $ENGINE"

echo "=== Building Node Dev Image ==="
$ENGINE build \
  -f Containerfile.node \
  -t node-dev:latest \
  -t node-dev:alpine${ALPINE_VERSION} \
  -t node-dev:${ALPINE_VERSION} \
  .

echo "=== Building Python Dev Image ==="
$ENGINE build \
  -f Containerfile.python \
  -t python-dev:latest \
  -t python-dev:alpine${ALPINE_VERSION} \
  -t python-dev:${ALPINE_VERSION} \
  .

echo "All images built and tagged successfully!"
