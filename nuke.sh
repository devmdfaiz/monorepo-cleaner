#!/usr/bin/env bash

set -e

ROOT="$(pwd)"

echo "======================================"
echo " Cleaning pnpm monorepo"
echo " Root: $ROOT"
echo "======================================"
echo

# --------------------------------------
# 1. Remove node_modules
# --------------------------------------
echo "[1/4] Removing node_modules..."

find "$ROOT" \
  -type d \
  -name "node_modules" \
  -prune \
  -exec rm -rf {} +

echo "✓ node_modules removed"
echo

# --------------------------------------
# 2. Remove dist and build directories
# --------------------------------------
echo "[2/4] Removing dist and build directories..."

find "$ROOT" \
  -type d \
  \( -name "dist" -o -name "build" \) \
  -prune \
  -exec rm -rf {} +

echo "✓ dist/build removed"
echo

# --------------------------------------
# 3. Remove local .pnpm-store
# --------------------------------------
echo "[3/4] Removing local .pnpm-store..."

if [ -d "$ROOT/.pnpm-store" ]; then
    rm -rf "$ROOT/.pnpm-store"
    echo "✓ $ROOT/.pnpm-store removed"
else
    echo "✓ No local .pnpm-store found"
fi

echo

# --------------------------------------
# 4. Remove actual pnpm store
# --------------------------------------
echo "[4/4] Removing pnpm store..."

STORE_PATH="$(pnpm store path 2>/dev/null || true)"

if [ -n "$STORE_PATH" ] && [ -d "$STORE_PATH" ]; then
    echo "Store: $STORE_PATH"
    rm -rf "$STORE_PATH"
    echo "✓ pnpm store removed"
else
    echo "✓ pnpm store not found"
fi

echo
echo "======================================"
echo " Cleanup complete!"
echo "======================================"
echo
echo "Run:"
echo "  pnpm install"