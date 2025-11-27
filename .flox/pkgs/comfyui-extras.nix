{ lib
, python3
, fetchFromGitHub
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "comfyui-extras";
  version = "0.3.75";  # Match ComfyUI version
  format = "other";

  # No source - this is a meta-package
  dontUnpack = true;
  dontBuild = true;
  doCheck = false;

  # Import all custom node dependency packages
  propagatedBuildInputs = (with python3.pkgs; [
    # From nixpkgs - Already available (12 packages)
    piexif
    simpleeval
    color-matcher
    numba
    gitpython
    rembg
    onnxruntime
    fairscale
    albumentations
    easydict
    pymatting
    pillow-heif
  ]) ++ [
    # Custom packages - Need to build (TODO)
    # colour-science
    # clip-interrogator
    # pixeloe
    # transparent-background
    # img2texture
    # cstr
    # ffmpy
  ];

  installPhase = ''
    mkdir -p $out
    echo "${version}" > $out/version
  '';

  meta = with lib; {
    description = "Extra dependencies for ComfyUI custom nodes";
    homepage = "https://github.com/barstoolbluz/build-comfyui-extras";
    license = licenses.mit;
    platforms = platforms.unix;  # Linux + macOS
  };
}
