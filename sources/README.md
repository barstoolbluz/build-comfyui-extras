# Vendored Sources

This directory contains vendored copies of all custom package sources.

## Architecture

**These sources are PRIMARY, not backups.** All `.nix` files in `.flox/pkgs/` directly reference files in this directory:

```nix
# Example from colour-science.nix
src = ../../sources/colour_science-0.4.6-py3-none-any.whl;
```

## Why Vendored-First?

1. **True offline builds** - No network access required during build
2. **Permanent availability** - Builds work forever, even if PyPI/GitHub remove packages
3. **Complete reproducibility** - Exact sources committed to git with full history
4. **Version isolation** - Each ComfyUI version branch has its own frozen vendored sources

## Version Branching

Each ComfyUI version (e.g., 0.3.75, 0.3.76) gets its own git branch with its own vendored sources. This prevents:
- Git history bloat from updating large binaries
- Breakage of older version builds
- Confusion about which sources match which ComfyUI version

See [REPRODUCIBILITY.md](../REPRODUCIBILITY.md) for the complete version update workflow.

## Files

**PyPI Wheels (6 packages)**:
- `ffmpy-0.5.0-py3-none-any.whl`
- `colour_science-0.4.6-py3-none-any.whl`
- `clip_interrogator-0.6.0-py3-none-any.whl`
- `transparent_background-1.3.4-py3-none-any.whl`
- `color_matcher-0.6.0-py3-none-any.whl`
- `rembg-2.0.68-py3-none-any.whl`

**PyPI Source Tarballs (1 package)**:
- `pixeloe-0.1.4.tar.gz`

**GitHub Tarballs (2 packages)**:
- `img2texture-d6159abea44a0b2cf77454d3d46962c8b21eb9d3.tar.gz`
- `cstr-0520c29a18a7a869a6e5983861d6f7a4c86f8e9b.tar.gz`

## Updating

When creating a new ComfyUI version branch:

1. **Create branch**: `git checkout -b 0.3.76`
2. **Update package versions** in `.nix` files if needed
3. **Re-vendor sources**: `./sources/vendor-sources.sh`
4. **Commit everything**: `git add sources/ .flox/pkgs/ && git commit -m "comfyui-extras 0.3.76"`

The `vendor-sources.sh` script downloads all packages fresh from PyPI/GitHub and places them in this directory.
