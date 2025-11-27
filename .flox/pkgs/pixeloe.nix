{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "pixeloe";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1asrhaw2la7gq93lcspn7h7lj143m8cqdd9ijfdkj9pr7qn3ll9d";
  };

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    pillow
    scipy
  ];

  pythonImportsCheck = [ "pixeloe" ];

  meta = with lib; {
    description = "Detail-Oriented Pixelization based on Contrast-Aware Outline Expansion";
    homepage = "https://github.com/KohakuBlueleaf/PixelOE";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
