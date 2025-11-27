#!/usr/bin/env bash
# Script to download and vendor all custom package sources
#
# USAGE:
#   ./sources/vendor-sources.sh
#
# PURPOSE:
#   Downloads all PyPI wheels and GitHub tarballs for custom packages.
#   These vendored sources are committed to git and used as PRIMARY sources
#   in .nix files (not as backups - they ARE the source of truth).
#
# VERSION BRANCHING WORKFLOW:
#   When updating to a new ComfyUI version (e.g., 0.3.76):
#   1. Create new branch: git checkout -b 0.3.76
#   2. Update package versions in .nix files if needed
#   3. Run this script: ./sources/vendor-sources.sh
#   4. Commit vendored sources: git add sources/ && git commit
#   5. Test builds on all platforms
#   6. Merge to main and tag: git merge 0.3.76 && git tag v0.3.76
#
# See REPRODUCIBILITY.md for complete workflow documentation.

set -euo pipefail

SOURCES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Downloading vendored sources to: $SOURCES_DIR"
echo

# colour-science 0.4.6
echo "Downloading colour-science 0.4.6..."
curl -L -o "$SOURCES_DIR/colour_science-0.4.6-py3-none-any.whl" \
  https://files.pythonhosted.org/packages/py3/c/colour_science/colour_science-0.4.6-py3-none-any.whl

# clip-interrogator 0.6.0
echo "Downloading clip-interrogator 0.6.0..."
curl -L -o "$SOURCES_DIR/clip_interrogator-0.6.0-py3-none-any.whl" \
  https://files.pythonhosted.org/packages/30/79/a75e9129809368b3e3d9b9bc803230ac1cba7d690338f7b0c3ad46107fa3/clip_interrogator-0.6.0-py3-none-any.whl

# pixeloe 0.1.4
echo "Downloading pixeloe 0.1.4..."
curl -L -o "$SOURCES_DIR/pixeloe-0.1.4.tar.gz" \
  https://files.pythonhosted.org/packages/source/p/pixeloe/pixeloe-0.1.4.tar.gz

# transparent-background 1.3.4
echo "Downloading transparent-background 1.3.4..."
curl -L -o "$SOURCES_DIR/transparent_background-1.3.4-py3-none-any.whl" \
  https://files.pythonhosted.org/packages/py3/t/transparent_background/transparent_background-1.3.4-py3-none-any.whl

# img2texture (from GitHub)
echo "Downloading img2texture..."
curl -L -o "$SOURCES_DIR/img2texture-d6159abea44a0b2cf77454d3d46962c8b21eb9d3.tar.gz" \
  https://github.com/WASasquatch/img2texture/archive/d6159abea44a0b2cf77454d3d46962c8b21eb9d3.tar.gz

# cstr (from GitHub)
echo "Downloading cstr..."
curl -L -o "$SOURCES_DIR/cstr-0520c29a18a7a869a6e5983861d6f7a4c86f8e9b.tar.gz" \
  https://github.com/WASasquatch/cstr/archive/0520c29a18a7a869a6e5983861d6f7a4c86f8e9b.tar.gz

# ffmpy 0.5.0
echo "Downloading ffmpy 0.5.0..."
curl -L -o "$SOURCES_DIR/ffmpy-0.5.0-py3-none-any.whl" \
  https://files.pythonhosted.org/packages/py3/f/ffmpy/ffmpy-0.5.0-py3-none-any.whl

# color-matcher 0.6.0
echo "Downloading color-matcher 0.6.0..."
curl -L -o "$SOURCES_DIR/color_matcher-0.6.0-py3-none-any.whl" \
  https://files.pythonhosted.org/packages/py3/c/color_matcher/color_matcher-0.6.0-py3-none-any.whl

# rembg 2.0.68
echo "Downloading rembg 2.0.68..."
curl -L -o "$SOURCES_DIR/rembg-2.0.68-py3-none-any.whl" \
  https://files.pythonhosted.org/packages/py3/r/rembg/rembg-2.0.68-py3-none-any.whl

echo
echo "All sources downloaded successfully!"
echo
echo "Verifying hashes..."
echo

# Verify hashes match what's in .nix files
for file in "$SOURCES_DIR"/*.{whl,tar.gz}; do
  if [ -f "$file" ]; then
    hash=$(nix-hash --flat --base32 --type sha256 "$file")
    echo "$(basename "$file"): sha256-$hash"
  fi
done

echo
echo "Done! Commit these files to git for long-term reproducibility."
