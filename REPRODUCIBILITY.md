# Reproducibility Architecture

This document explains how `comfyui-extras` achieves long-term reproducibility.

## Overview

The `comfyui-extras` package is designed for **long-term reproducible builds** using a vendored-first strategy:

1. **Primary**: Use vendored sources committed to git (sources in `sources/`)
2. **Versioned**: Git branches track ComfyUI versions (e.g., branch `0.3.75` for ComfyUI 0.3.75)
3. **Platform-aware**: Graceful degradation on unsupported platforms

## Hash Verification vs Source Availability

It's important to understand the difference:

- **Hash verification** (what Nix provides): Ensures that IF a source exists, it's byte-for-byte identical
- **Source availability** (what vendoring provides): Ensures sources exist even if upstream disappears

Our approach prioritizes **source availability**:
- `.nix` files directly reference vendored sources in `sources/`
- No network fetches during build (fully offline-capable)
- Complete git history of all source changes

## Current Build Strategy

### Normal Operation
When you run `flox build comfyui-extras`:

1. Nix reads each `.nix` file
2. Uses `src = ../../sources/package-version.whl` (local file path)
3. Builds from vendored source in git
4. No network access required - fully offline builds

### All Sources Are Vendored
All 9 custom packages use vendored sources as PRIMARY:

```nix
# All packages use this pattern:
python3.pkgs.buildPythonPackage rec {
  pname = "example";
  version = "1.0.0";

  # Direct reference to vendored source
  src = ../../sources/example-1.0.0-py3-none-any.whl;
  ...
}
```

## Vendored Sources

### What's Vendored?

All 9 custom packages have vendored sources in `sources/`:

**PyPI Wheels (5 packages)**:
- `ffmpy-0.5.0-py3-none-any.whl`
- `colour_science-0.4.6-py3-none-any.whl`
- `clip_interrogator-0.6.0-py3-none-any.whl`
- `transparent_background-1.3.4-py3-none-any.whl`
- `color_matcher-0.6.0-py3-none-any.whl`
- `rembg-2.0.68-py3-none-any.whl`

**PyPI Source (1 package)**:
- `pixeloe-0.1.4.tar.gz`

**GitHub Tarballs (2 packages)**:
- `img2texture-e3b499bd92bd3646ba583e506f755c6f02ef5d8f.tar.gz`
- `cstr-e3b499bd92bd3646ba583e506f755c6f02ef5d8f.tar.gz`

### Verification

Run `./sources/vendor-sources.sh` to:
1. Re-download all sources
2. Verify hashes match `.nix` files
3. Detect if upstream sources have changed

### Why Git-Track Binary Files?

We commit `.whl` and `.tar.gz` files directly to git because:

1. **Complete reproducibility**: Clone repo → build works offline
2. **Auditability**: Full history of source changes
3. **No external dependencies**: Don't rely on LFS, S3, or other storage

`.gitattributes` marks these as binary to prevent text processing.

## Package Sources

### 10 Packages from nixpkgs
These are already in Nix's binary cache and don't need vendoring:
- piexif, simpleeval, numba, gitpython, onnxruntime
- fairscale, albumentations, easydict, pymatting, pillow-heif

### 9 Custom Packages

| Package | Why Custom? | Source Type |
|---------|-------------|-------------|
| colour-science | Not in nixpkgs | PyPI wheel |
| clip-interrogator | Not in nixpkgs | PyPI wheel |
| ffmpy | Not in nixpkgs | PyPI wheel |
| cstr | Not in nixpkgs | GitHub |
| img2texture | Not in nixpkgs | GitHub |
| pixeloe | Not in nixpkgs | PyPI source |
| transparent-background | Not in nixpkgs | PyPI wheel |
| color-matcher | **nixpkgs broken on macOS** | PyPI wheel |
| rembg | **nixpkgs x86_64-linux only** | PyPI wheel |

## Platform-Specific Handling

### Excluded Packages

**aarch64-linux excludes 2 packages**:
- pixeloe (requires kornia-rs, which has `badPlatforms = ["aarch64-linux"]`)
- transparent-background (also requires kornia-rs)

Handled in `comfyui-extras.nix`:
```nix
] ++ lib.optionals (!stdenv.hostPlatform.isAarch64 || !stdenv.hostPlatform.isLinux) [
  pixeloe
  transparent-background
]
```

**All Darwin (macOS) platforms exclude 1 package**:
- albumentations (depends on stringzilla which has C compilation issues with Apple SDK on both x86_64 and aarch64)

Handled in `comfyui-extras.nix`:
```nix
] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (with python3.pkgs; [
  albumentations
])
```

Result: **19 packages on Linux x86_64, 17 on Linux aarch64, 18 on macOS (all architectures)**

## Nix Binary Cache

**Important**: Only nixpkgs packages are cached in the official Nix binary cache.

- **Cached (10 packages)**: piexif, simpleeval, numba, etc. - instant binary downloads
- **Not cached (9 packages)**: All custom packages must be built from source on your machine

This means first build takes time to compile 9 packages. Subsequent builds use local Nix store.

## Git Branching Strategy for Version Management

### Branch Structure

**Each ComfyUI version gets its own git branch:**

- `main` → Latest stable ComfyUI version (currently 0.3.75)
- `0.3.75` → Frozen version for ComfyUI 0.3.75
- `0.3.76` → Future version for ComfyUI 0.3.76
- etc.

### Why Branch Per Version?

Vendored sources are **large binary files** committed to git. Rebasing or updating these on a single branch would:
- Create massive git history bloat
- Make it impossible to go back to previous ComfyUI versions
- Break reproducibility for older builds

**Solution**: Each version lives on its own branch with its own vendored sources.

### Version Update Workflow

When ComfyUI releases a new version (e.g., 0.3.76):

1. **Create version branch from main**:
   ```bash
   git checkout main
   git checkout -b 0.3.76
   ```

2. **Update version in comfyui-extras.nix**:
   ```nix
   version = "0.3.76";  # Match ComfyUI version
   ```

3. **Check for dependency changes**:
   - Review ComfyUI release notes
   - Check if custom nodes added new dependencies
   - Test with representative workflows

4. **Update packages if needed**:
   - Add new `.nix` files for new dependencies
   - Update versions of existing packages
   - Update `propagatedBuildInputs` in `comfyui-extras.nix`

5. **Re-vendor all sources**:
   ```bash
   # Download updated sources
   ./sources/vendor-sources.sh

   # Commit ALL changes including binaries
   git add sources/
   git add .flox/pkgs/
   git commit -m "comfyui-extras 0.3.76: Update vendored sources"
   ```

6. **Test on all platforms**:
   ```bash
   flox build --system x86_64-linux comfyui-extras
   flox build --system aarch64-linux comfyui-extras
   flox build --system x86_64-darwin comfyui-extras
   flox build --system aarch64-darwin comfyui-extras
   ```

7. **Merge to main and tag**:
   ```bash
   git checkout main
   git merge 0.3.76
   git tag v0.3.76
   git push origin main 0.3.76 --tags
   ```

8. **Publish to FloxHub**:
   ```bash
   flox publish -o barstoolbluz comfyui-extras
   ```

### Accessing Specific Versions

Users can target specific branches:

```bash
# Install from main (latest)
flox install barstoolbluz/comfyui-extras

# Install specific version via git branch
flox install barstoolbluz/comfyui-extras@0.3.75

# Or in manifest.toml
[install]
comfyui-extras.pkg-path = "barstoolbluz/comfyui-extras@0.3.75"
```

### Branch Maintenance

- **main branch**: Always points to latest stable ComfyUI version
- **Version branches**: Frozen after release (no updates except critical bugs)
- **Old branches**: Never deleted - provides permanent reproducibility

## Long-Term Maintenance

### Adding New Packages

See [PACKAGING.md](PACKAGING.md) for step-by-step guide.

Key steps:
1. Check if package exists in nixpkgs first
2. Create `.flox/pkgs/packagename.nix` if needed
3. Add to `propagatedBuildInputs` in `comfyui-extras.nix`
4. Build and test
5. Add vendored source with `./sources/vendor-sources.sh`
6. Commit everything including binary files

## Comparison to Other Approaches

### vs pip install
- **pip**: Downloads from PyPI at runtime, no version locking, breaks system packages
- **comfyui-extras**: Pre-built packages, exact versions, isolated environment

### vs requirements.txt
- **requirements.txt**: Source available until PyPI removes it
- **comfyui-extras**: Source vendored in git, survives PyPI deletion

### vs Nix flakes with follows
- **flakes**: Lock file points to upstream, no local backup
- **comfyui-extras**: Git-tracked vendored sources, complete offline builds

### vs Docker with COPY
- **Docker**: Binary blob, no source visibility, rebuild from scratch
- **comfyui-extras**: Source-based, incrementally rebuildable, auditable

## Testing Reproducibility

### Verify Hash Consistency
```bash
# Download sources fresh
./sources/vendor-sources.sh

# Should output "All hashes match!"
```

### Test Offline Build
```bash
# Disconnect network
sudo ifconfig eth0 down  # or your network interface

# Should still build using Nix store + vendored sources
flox build comfyui-extras
```

### Cross-Platform Check
```bash
# Build on all platforms
flox build --system x86_64-linux comfyui-extras
flox build --system aarch64-linux comfyui-extras
flox build --system x86_64-darwin comfyui-extras
flox build --system aarch64-darwin comfyui-extras
```

## Future Improvements

Possible enhancements to reproducibility:

1. **Primary vendored sources**: Modify `.nix` files to use `sources/` as primary, not backup
2. **Automated vendoring**: Pre-commit hook to auto-vendor when `.nix` files change
3. **Mirror infrastructure**: Host our own PyPI mirror for custom packages
4. **Source code vendoring**: For GitHub packages, vendor actual source code not just tarballs
5. **Binary cache**: Host our own Nix binary cache for pre-built custom packages

## References

- [Nix Manual: Reproducible Builds](https://nixos.org/manual/nix/stable/)
- [REPRODUCIBLE-BUILD-ARCHITECTURE.md](https://github.com/anthropics/claude-code/docs/reproducible-builds) (original inspiration)
- [PyPI JSON API](https://warehouse.pypa.io/api-reference/json.html) for hash verification
