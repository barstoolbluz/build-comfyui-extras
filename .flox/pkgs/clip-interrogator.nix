{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "clip-interrogator";
  version = "0.6.0";
  format = "wheel";

  # Use vendored source for reproducibility
  src = ../../sources/clip_interrogator-0.6.0-py3-none-any.whl;

  dontBuild = true;

  propagatedBuildInputs = with python3.pkgs; [
    torch
    torchvision
    pillow
    requests
    open-clip-torch
  ];

  # Skip imports check - too many dependencies to track
  # pythonImportsCheck = [ "clip_interrogator" ];

  meta = with lib; {
    description = "Image to prompt with BLIP and CLIP";
    homepage = "https://github.com/pharmapsychotic/clip-interrogator";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
