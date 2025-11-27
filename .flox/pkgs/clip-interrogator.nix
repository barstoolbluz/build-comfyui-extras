{ lib, python3, fetchurl }:

python3.pkgs.buildPythonPackage rec {
  pname = "clip-interrogator";
  version = "0.6.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/30/79/a75e9129809368b3e3d9b9bc803230ac1cba7d690338f7b0c3ad46107fa3/clip_interrogator-0.6.0-py3-none-any.whl";
    sha256 = "075xxam95adh50sanxfcxf70zajq2vy47sbr85dh03qpvgwnnz6d";
  };

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
