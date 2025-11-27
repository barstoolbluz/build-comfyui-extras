{ lib
, python3
, fetchFromGitHub
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "comfyui-extras";
  version = "0.1.0";
  format = "other";

  # No source - this is a meta-package
  dontUnpack = true;
  dontBuild = true;
  doCheck = false;

  # Import all custom node dependency packages
  propagatedBuildInputs = with python3.pkgs; [
    # Tier 1: Lightweight, commonly needed
    piexif
    colour-science
    simpleeval
    color-matcher
    numba
    gitpython

    # Tier 2: Moderate deps, widely used
    rembg
    onnxruntime

    # Tier 3: Heavy but useful
    clip-interrogator
    fairscale
    transparent-background
    pixeloe

    # Additional deps for various custom nodes
    albumentations
    easydict
    pymatting
    pillow-heif

    # WASasquatch git-based packages
    img2texture
    cstr
    ffmpy

    # Additional utilities
    wget-python
  ];

  installPhase = ''
    mkdir -p $out
    echo "${version}" > $out/version
  '';

  meta = with lib; {
    description = "Extra dependencies for ComfyUI custom nodes";
    homepage = "https://github.com/barstoolbluz/build-comfyui-extras";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
