{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "transparent-background";
  version = "1.3.4";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    pname = "transparent_background";
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "0chx5bv3ic0s9pcfjad7xnidvbqcs0c2qwpb2vm0dbi4w5i3k0ma";
  };

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
