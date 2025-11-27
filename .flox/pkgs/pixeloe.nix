{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "pixeloe";
  version = "0.1.4";
  format = "pyproject";

  # Use vendored source for reproducibility
  src = ../../sources/pixeloe-0.1.4.tar.gz;

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    pillow
    scipy
    opencv4
    torch
    kornia
  ];

  # Disable runtime deps check - it looks for "opencv-python" but we provide "opencv4"
  dontCheckRuntimeDeps = true;

  # Skip imports check - too many dependencies to track
  # pythonImportsCheck = [ "pixeloe" ];

  meta = with lib; {
    description = "Detail-Oriented Pixelization based on Contrast-Aware Outline Expansion";
    homepage = "https://github.com/KohakuBlueleaf/PixelOE";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
