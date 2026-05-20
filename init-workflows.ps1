# init-workflows.ps1
$workflows = @{
    ".github/workflows/build.yml" = @"
name: Build

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install
      - run: npm run build
      - run: npm run dist
      - uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: dist/
"@

    ".github/workflows/release.yml" = @"
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install
      - run: npm run build
      - run: npm run dist
      - uses: actions/upload-artifact@v4
        with:
          name: release-build
          path: dist/
"@

    ".github/workflows/cleanup.yml" = @"
name: Git Cleanup

on:
  schedule:
    - cron: '0 3 * * 0'
  workflow_dispatch:

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          git gc --prune=now
          git repack -ad
"@
}

foreach ($file in $workflows.Keys) {
    $content = $workflows[$file]
    $dir = Split-Path $file
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir }
    Set-Content -Path $file -Value $content -Force
    Write-Host "✅ Archivo actualizado: $file"
}
