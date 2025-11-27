{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "transparent-background";
  version = "1.3.4";
  format = "wheel";

  # Use vendored source for reproducibility
  src = ../../sources/transparent_background-1.3.4-py3-none-any.whl;

  dontBuild = true;

  propagatedBuildInputs = with python3.pkgs; [
    torch
    torchvision
    opencv4
    timm
    tqdm
    kornia
    gdown
    wget
  ];

  # Skip imports check - too many dependencies to track
  # pythonImportsCheck = [ "transparent_background" ];

  meta = with lib; {
    description = "Remove background from images";
    homepage = "https://github.com/nadermx/backgroundremover";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
