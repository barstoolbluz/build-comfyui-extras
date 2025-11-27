# ComfyUI Extras - Custom Node Dependencies

Production-ready package containing all common ComfyUI custom node dependencies, properly packaged for Nix/Flox with long-term reproducibility.

## Overview

This package provides a batteries-included collection of Python dependencies commonly required by ComfyUI custom nodes. Instead of pip-installing with `--break-system-packages`, users can install this single package for a clean, reproducible setup.

## Version Compatibility

- **ComfyUI Extras Version**: 0.3.75
- **Compatible with ComfyUI**: 0.3.75

**Version Policy**: comfyui-extras version matches ComfyUI version exactly. When ComfyUI updates to 0.3.76, comfyui-extras will also update to 0.3.76.

## Platform Support

| Platform | Packages | Notes |
|----------|----------|-------|
| x86_64-linux | 19 packages (all) | Full support |
| aarch64-linux | 17 packages | Excludes: pixeloe, transparent-background (kornia-rs broken) |
| x86_64-darwin | 19 packages (all) | Full support |
| aarch64-darwin | 18 packages | Excludes: albumentations (stringzilla compilation issue) |

## Included Packages

### From nixpkgs (10 packages)
- ✅ piexif - Image EXIF metadata
- ✅ simpleeval - Safe expression evaluation
- ✅ numba - JIT compiler
- ✅ gitpython - Git operations
- ✅ onnxruntime - ONNX inference
- ✅ fairscale - Distributed training
- ✅ albumentations - Image augmentation (not on aarch64-darwin)*
- ✅ easydict - Dict with attribute access
- ✅ pymatting - Alpha matting
- ✅ pillow-heif - HEIF support

\* Not available on aarch64-darwin due to stringzilla compilation issues

### Custom Built (9 packages)
- ✅ colour-science 0.4.6 - Color manipulation
- ✅ clip-interrogator 0.6.0 - CLIP image interrogation
- ✅ pixeloe 0.1.4 - Pixel art generation*
- ✅ transparent-background 1.3.4 - Background removal*
- ✅ img2texture - Seamless texture generation
- ✅ cstr - String utilities
- ✅ ffmpy 0.5.0 - FFmpeg wrapper
- ✅ color-matcher 0.6.0 - Color matching (custom: nixpkgs broken on macOS)
- ✅ rembg 2.0.68 - Background removal (custom: nixpkgs x86_64-linux only)

\* Not available on aarch64-linux due to kornia-rs dependency

## Installation

### For Users

```toml
# Add to your ComfyUI environment's manifest.toml
[install]
comfyui-extras.pkg-path = "barstoolbluz/comfyui-extras@0.3.75"
```

Or install directly:
```bash
flox install barstoolbluz/comfyui-extras
```

### For Developers

```bash
# Clone and build
git clone https://github.com/barstoolbluz/build-comfyui-extras
cd build-comfyui-extras
flox build comfyui-extras

# Publish to your catalog
flox publish -o yourorg comfyui-extras
```

## Reproducibility

This package is built for **long-term reproducible builds**:

1. **Vendored sources as primary** - All custom packages use vendored sources in `sources/` directory
2. **Fully offline builds** - No network fetches required, build from git-committed sources
3. **Version branching** - Each ComfyUI version has its own git branch with frozen vendored sources
4. **Platform-specific handling** - Graceful degradation on unsupported platforms
5. **Complete git history** - All source changes tracked and auditable

**Key principle**: `.nix` files reference vendored sources directly (`src = ../../sources/package.whl`), NOT upstream URLs. This ensures builds work forever, even if PyPI or GitHub removes packages.

See [REPRODUCIBILITY.md](REPRODUCIBILITY.md) for complete architecture and version update workflow.

## Custom Nodes Supported

This package provides dependencies for popular custom nodes:

- ✅ **ComfyUI-Image-Saver** - piexif
- ✅ **was-node-suite-comfyui** - All WASasquatch packages
- ✅ **ComfyUI_essentials** - numba, colour-science, rembg, pixeloe, transparent-background
- ✅ **ComfyUI-KJNodes** - color-matcher
- ✅ **efficiency-nodes-comfyui** - clip-interrogator, simpleeval

## Documentation

- [PACKAGING.md](PACKAGING.md) - Guide for adding/updating packages
- [REPRODUCIBILITY.md](REPRODUCIBILITY.md) - Reproducible build architecture
- [sources/README.md](sources/README.md) - Vendored sources documentation

## Contributing

See [PACKAGING.md](PACKAGING.md) for how to add or update packages.

## License

MIT (packaging infrastructure)

Individual packages maintain their respective licenses.
