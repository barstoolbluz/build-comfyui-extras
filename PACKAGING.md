# ComfyUI Extras Packaging Guide

Guide for packaging ComfyUI custom node dependencies.

## Quick Reference

### Get PyPI Package Hash

```bash
# For wheel packages
nix-prefetch-url https://files.pythonhosted.org/packages/py3/p/piexif/piexif-1.1.3-py2.py3-none-any.whl

# For source packages
nix-prefetch-url --unpack https://files.pythonhosted.org/packages/source/s/simpleeval/simpleeval-1.0.3.tar.gz
```

### Get GitHub Package Hash

```bash
# Using nix-prefetch-github (install with: nix-env -iA nixpkgs.nix-prefetch-github)
nix-prefetch-github WASasquatch img2texture --rev v1.0.6

# Using nix-prefetch-git
nix-prefetch-git https://github.com/WASasquatch/img2texture --rev v1.0.6
```

### Package Template (Wheel)

```nix
{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "package-name";
  version = "x.y.z";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    hash = "sha256-REPLACE_WITH_HASH";
  };

  pythonImportsCheck = [ "package_name" ];

  meta = with lib; {
    description = "Package description";
    homepage = "https://github.com/author/package";
    license = licenses.mit;
  };
}
```

### Package Template (Source)

```nix
{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "package-name";
  version = "x.y.z";
  format = "setuptools";  # or "pyproject"

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-REPLACE_WITH_HASH";
  };

  propagatedBuildInputs = with python3.pkgs; [
    # List runtime dependencies here
  ];

  pythonImportsCheck = [ "package_name" ];

  meta = with lib; {
    description = "Package description";
    homepage = "https://pypi.org/project/package-name/";
    license = licenses.mit;
  };
}
```

### Package Template (GitHub)

```nix
{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "package-name";
  version = "x.y.z";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "author";
    repo = "package-name";
    rev = "v${version}";  # or specific commit
    hash = "sha256-REPLACE_WITH_HASH";
  };

  propagatedBuildInputs = with python3.pkgs; [
    # Dependencies
  ];

  pythonImportsCheck = [ "package_name" ];

  meta = with lib; {
    description = "Package description";
    homepage = "https://github.com/author/package-name";
    license = licenses.mit;
  };
}
```

## Workflow for Adding a Package

### 1. Find Package Information

```bash
# Check PyPI for version and dependencies
pip show package-name

# Or visit https://pypi.org/project/package-name/
```

### 2. Get the Hash

#### For PyPI Wheel:
```bash
# Find the wheel URL from PyPI
# Example: https://files.pythonhosted.org/packages/py3/p/piexif/piexif-1.1.3-py2.py3-none-any.whl

nix-prefetch-url <WHEEL_URL>
```

#### For GitHub:
```bash
nix-prefetch-github OWNER REPO --rev TAG_OR_COMMIT
```

### 3. Create Package File

```bash
# Create .flox/pkgs/package-name.nix
cd ~/dev/builds/build-comfyui-extras
touch .flox/pkgs/package-name.nix
```

### 4. Add to comfyui-extras.nix

```nix
propagatedBuildInputs = with python3.pkgs; [
  # ... existing packages ...
  package-name
];
```

### 5. Test the Build

```bash
cd ~/dev/builds/build-comfyui-extras
flox activate

# Build the package
flox build comfyui-extras

# Test the import
flox activate -- python3 -c "import package_name; print('Success!')"
```

### 6. Handle Dependencies

If a package has dependencies, add them to `propagatedBuildInputs`:

```nix
propagatedBuildInputs = with python3.pkgs; [
  numpy
  pillow
  requests
];
```

## Common Issues

### Issue: "error: attribute 'package-name' missing"

**Solution**: The package name in Python uses underscores, but Nix uses hyphens:
```nix
# If import is: import package_name
pythonImportsCheck = [ "package_name" ];

# But pname is:
pname = "package-name";
```

### Issue: "hash mismatch"

**Solution**: Update the hash with the actual value from nix-prefetch:
```bash
# Get the hash
nix-prefetch-url <URL>

# Update in .nix file
hash = "sha256-XXXXX...";
```

### Issue: "ModuleNotFoundError: No module named 'dependency'"

**Solution**: Add missing dependency to `propagatedBuildInputs`:
```nix
propagatedBuildInputs = with python3.pkgs; [
  dependency-package
];
```

## Package Priority Order

Build packages in this order:

1. **No dependencies**: piexif, simpleeval, easydict
2. **Minimal deps**: colour-science, color-matcher, pixeloe
3. **Git packages**: img2texture, cstr, ffmpy
4. **Moderate deps**: numba, gitpython, albumentations
5. **Heavy deps**: rembg, onnxruntime, clip-interrogator, fairscale

## Testing

### Unit Test
```bash
flox activate -- python3 -c "import package_name; print(package_name.__version__)"
```

### Integration Test
```bash
# Install in a ComfyUI environment
cd ~/dev/floxenvs/comfyui
flox install ../builds/build-comfyui-extras#comfyui-extras

# Test with custom nodes
flox services restart comfyui
flox services logs comfyui | grep "IMPORT FAILED"
```

## Publishing

```bash
# Build final package
cd ~/dev/builds/build-comfyui-extras
flox build comfyui-extras

# Publish to catalog
flox publish -o barstoolbluz comfyui-extras
```

## Version Management

**Policy**: comfyui-extras version ALWAYS matches ComfyUI version exactly.

When ComfyUI updates (e.g., 0.3.75 → 0.3.76):

1. Update version in `.flox/pkgs/comfyui-extras.nix`:
   ```nix
   version = "0.3.76";  # Match ComfyUI version
   ```

2. Test extras package with new ComfyUI version
3. Update individual package dependencies if needed
4. Rebuild and republish

```bash
# Update version
cd ~/dev/builds/build-comfyui-extras
# Edit .flox/pkgs/comfyui-extras.nix

# Test build
flox build comfyui-extras

# Republish
flox publish -o barstoolbluz comfyui-extras
```

Users can then install matching versions:
```toml
[install]
comfyui.pkg-path = "barstoolbluz/comfyui@0.3.76"
comfyui-extras.pkg-path = "barstoolbluz/comfyui-extras@0.3.76"
```
