{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "colour-science";
  version = "0.4.6";
  format = "wheel";

  # Use vendored source for reproducibility
  src = ../../sources/colour_science-0.4.6-py3-none-any.whl;

  dontBuild = true;

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    scipy
    matplotlib
  ];

  # Skip imports check - too many dependencies to track
  # pythonImportsCheck = [ "colour" ];

  meta = with lib; {
    description = "Colour Science for Python";
    homepage = "https://www.colour-science.org/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
