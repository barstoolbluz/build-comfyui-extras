{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "clip-interrogator";
  version = "0.6.0";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    pname = "clip_interrogator";
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "075xxam95adh50sanxfcxf70zajq2vy47sbr85dh03qpvgwnnz6d";
  };

  dontBuild = true;

  propagatedBuildInputs = with python3.pkgs; [
    torch
    torchvision
    pillow
    requests
  ];

  pythonImportsCheck = [ "clip_interrogator" ];

  meta = with lib; {
    description = "Image to prompt with BLIP and CLIP";
    homepage = "https://github.com/pharmapsychotic/clip-interrogator";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
