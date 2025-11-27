{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "pixeloe";
  version = "0.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LWuVp6elV+B6bxV41tr6iErcQlzBqxbYzsLm/yZZSQE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

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
