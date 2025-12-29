{ lib
, python3
, callPackage
, stdenv
}:

let
  # Custom packages built in .flox/pkgs/
  colour-science = callPackage ./colour-science.nix { };
  clip-interrogator = callPackage ./clip-interrogator.nix { };
  pixeloe = callPackage ./pixeloe.nix { };
  transparent-background = callPackage ./transparent-background.nix { };
  img2texture = callPackage ./img2texture.nix { };
  cstr = callPackage ./cstr.nix { };
  ffmpy = callPackage ./ffmpy.nix { };
  color-matcher = callPackage ./color-matcher.nix { };  # Custom build - nixpkgs version broken on macOS
  rembg = callPackage ./rembg.nix { };  # Custom build - nixpkgs version x86_64-linux only
in

python3.pkgs.buildPythonPackage rec {
  pname = "comfyui-extras";
  version = "0.6.0";  # Match ComfyUI version
  format = "other";

  # No source - this is a meta-package
  dontUnpack = true;
  dontBuild = true;
  doCheck = false;

  # Import all custom node dependency packages
  propagatedBuildInputs = (with python3.pkgs; [
    # From nixpkgs - Always available (9 packages)
    piexif
    simpleeval
    numba
    gitpython
    onnxruntime
    fairscale
    easydict
    pymatting
    pillow-heif
  ]) ++ lib.optionals (!stdenv.hostPlatform.isDarwin) (with python3.pkgs; [
    # Broken on all Darwin (macOS) platforms due to stringzilla compilation issues
    albumentations
  ]) ++ [
    # Custom packages - Always included (7 packages)
    colour-science
    clip-interrogator
    img2texture
    cstr
    ffmpy
    color-matcher  # Custom build - nixpkgs version broken on macOS
    rembg  # Custom build - nixpkgs version x86_64-linux only
  ] ++ lib.optionals (!stdenv.hostPlatform.isAarch64 || !stdenv.hostPlatform.isLinux) [
    # Custom packages - Conditional (2 packages, excluded on aarch64-linux due to kornia-rs)
    pixeloe
    transparent-background
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
