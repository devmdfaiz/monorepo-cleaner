# pnpm Monorepo Cleanup Script

A simple cleanup script for pnpm monorepos that removes dependencies, pnpm store data, and generated build artifacts before a fresh installation.

## What It Removes

The script recursively removes:

* `node_modules`
* `dist`
* `build`
* `.pnpm-store`
* The pnpm store returned by `pnpm store path`

It does **not** remove:

* `package.json`
* `pnpm-lock.yaml`
* `pnpm-workspace.yaml`
* Source code
* Configuration files

## Example Monorepo Structure

The script can be used with a structure like:

```text
my-monorepo/
├── apps/
│   ├── web/
│   │   ├── src/
│   │   ├── node_modules/    # removed
│   │   ├── dist/            # removed
│   │   └── build/           # removed
│   │
│   ├── api/
│   │   ├── src/
│   │   ├── node_modules/    # removed
│   │   └── dist/            # removed
│   │
│   └── admin/
│       ├── src/
│       ├── node_modules/    # removed
│       └── build/           # removed
│
├── packages/
│   ├── ui/
│   │   ├── src/
│   │   └── node_modules/    # removed
│   │
│   ├── database/
│   │   ├── src/
│   │   └── dist/            # removed
│   │
│   └── config/
│
├── node_modules/             # removed
├── .pnpm-store/              # removed
├── package.json
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
└── clean-pnpm.sh
```

## Script

Save the cleanup script as `clean-pnpm.sh` in the monorepo root.

Make it executable:

```bash
chmod +x clean-pnpm.sh
```

Then run:

```bash
./clean-pnpm.sh
```

## Fresh Installation

After cleanup, reinstall all dependencies:

```bash
pnpm install
```

Or simply:

```bash
./clean-pnpm.sh && pnpm install
```

## How It Works

### 1. Remove `node_modules`

The script searches recursively from the current directory and removes every `node_modules` directory.

```bash
find "$ROOT" \
  -type d \
  -name "node_modules" \
  -prune \
  -exec rm -rf {} +
```

This handles dependencies installed at both the workspace root and individual apps/packages.

### 2. Remove Build Artifacts

It also searches for and removes:

```text
dist/
build/
```

This is useful when stale compiled output is causing unexpected behavior.

### 3. Remove Local `.pnpm-store`

If the repository contains a local:

```text
.pnpm-store/
```

directory, it is removed.

### 4. Remove the pnpm Store

The script uses:

```bash
pnpm store path
```

to determine the configured pnpm store location instead of assuming a fixed path.

The detected store is then removed.

## Safety

The script is intentionally limited to generated dependency and build directories.

It does **not** delete the lockfile or project source.

However, because it uses:

```bash
rm -rf
```

the deleted directories cannot be recovered through the normal filesystem trash.

Make sure you are running it from the correct monorepo root.

## Recommended Workflow

When you need a completely fresh pnpm installation:

```bash
cd /path/to/my-monorepo

./clean-pnpm.sh

pnpm install
```

This gives you a clean workspace while preserving the existing `pnpm-lock.yaml`.
