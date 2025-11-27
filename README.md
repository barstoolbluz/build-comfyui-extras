# ComfyUI Extras - Custom Node Dependencies

Production-ready package containing all common ComfyUI custom node dependencies, properly packaged for Nix/Flox.

## Overview

This package provides a batteries-included collection of Python dependencies commonly required by ComfyUI custom nodes. Instead of pip-installing with `--break-system-packages`, users can install this single package for a clean, reproducible setup.

## Version Compatibility

- **ComfyUI Extras Version**: 0.1.0
- **Compatible with ComfyUI**: 0.3.75+

## Included Packages

### Tier 1: Lightweight, Essential
- ✅ `piexif` - Image EXIF metadata manipulation
- ✅ `simpleeval` - Safe expression evaluation
- ⏳ `colour-science` - Color manipulation utilities
- ⏳ `color-matcher` - Color matching between images
- ⏳ `numba` - JIT compiler for Python
- ⏳ `gitpython` - Git operations from Python

### Tier 2: Moderate, Widely Used
- ⏳ `rembg` - Background removal
- ⏳ `onnxruntime` - ONNX model inference

### Tier 3: Heavy but Useful
- ⏳ `clip-interrogator` - CLIP-based image interrogation
- ⏳ `fairscale` - PyTorch distributed training
- ⏳ `transparent-background` - Transparent background generation
- ⏳ `pixeloe` - Pixel art generation

### Additional Dependencies
- ⏳ `albumentations` - Image augmentation library
- ⏳ `easydict` - Dictionary with attribute access
- ⏳ `pymatting` - Alpha matting toolbox
- ⏳ `pillow-heif` - HEIF image support

### WASasquatch Git Packages
- ⏳ `img2texture` - Texture generation from images
- ⏳ `cstr` - String utilities
- ⏳ `ffmpy` - FFmpeg wrapper

### Utilities
- ⏳ `wget-python` - Pure Python wget implementation

## Installation

### As a User

```toml
# In your ComfyUI environment manifest.toml
[install]
comfyui.pkg-path = "barstoolbluz/comfyui"
comfyui-extras.pkg-path = "barstoolbluz/comfyui-extras"
```

### As a Developer

```bash
# Clone the repository
cd ~/dev/builds
git clone <repo-url> build-comfyui-extras
cd build-comfyui-extras

# Activate the build environment
flox activate

# Build the package
flox build comfyui-extras

# Test the package
flox activate -- python3 -c "import piexif; import simpleeval; print('Success!')"

# Publish to your catalog
flox publish -o barstoolbluz comfyui-extras
```

## Package Development Status

**Legend:**
- ✅ Complete and tested
- ⏳ Package definition created, needs hash/testing
- ❌ Not yet started

### Priority 1 (Complete These First)
1. ✅ piexif
2. ✅ simpleeval
3. ⏳ img2texture (git package - get hash)
4. ⏳ cstr (git package - get hash)
5. ⏳ ffmpy (git package - get hash)

### Priority 2 (Common Dependencies)
6. ⏳ numba
7. ⏳ gitpython
8. ⏳ colour-science
9. ⏳ color-matcher
10. ⏳ easydict

### Priority 3 (Advanced Features)
11. ⏳ rembg
12. ⏳ onnxruntime
13. ⏳ clip-interrogator
14. ⏳ fairscale
15. ⏳ transparent-background
16. ⏳ pixeloe
17. ⏳ albumentations
18. ⏳ pymatting
19. ⏳ pillow-heif
20. ⏳ wget-python

## Custom Nodes Supported

This package provides dependencies for these popular custom nodes:

- ✅ **ComfyUI-Image-Saver** - piexif
- ✅ **rgthree-comfy** - No extra deps needed
- ✅ **UltimateSDUpscale** - No extra deps needed
- ⏳ **was-node-suite-comfyui** - All WASasquatch packages + many others
- ⏳ **ComfyUI_essentials** - numba, colour-science, rembg, pixeloe, transparent-background
- ⏳ **ComfyUI-KJNodes** - color-matcher
- ⏳ **efficiency-nodes-comfyui** - clip-interrogator, simpleeval

## Building Individual Packages

Each package in `.flox/pkgs/` can be built independently:

```bash
# Get the correct hash for a git package
nix-prefetch-github WASasquatch img2texture --rev v1.0.6

# Build and test individual package
flox build img2texture
flox activate -- python3 -c "import img2texture; print('Works!')"
```

## Contributing

To add a new package:

1. Create `.flox/pkgs/<package-name>.nix`
2. Add to `propagatedBuildInputs` in `comfyui-extras.nix`
3. Update this README with status
4. Test the build
5. Submit PR

## License

MIT (for the packaging infrastructure)

Individual packages maintain their respective licenses.
