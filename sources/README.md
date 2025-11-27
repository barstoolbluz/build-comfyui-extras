# Vendored Sources

This directory contains vendored copies of all custom package sources for long-term reproducibility.

## Why Vendor?

While we use PyPI URLs in our .nix files for convenience, we vendor sources here to ensure:
1. Builds work even if PyPI removes packages
2. Complete offline buildability
3. Compliance with reproducibility requirements

## Files

Each file should match the hash in the corresponding .nix file.

To verify:
```bash
nix-hash --flat --base32 --type sha256 <filename>
```

## Updating

When adding/updating a package:
1. Download from PyPI/GitHub
2. Place in this directory
3. Update .nix file to reference either URL or local file
4. Commit to git
