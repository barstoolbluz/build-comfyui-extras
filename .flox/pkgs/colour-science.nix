{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "colour-science";
  version = "0.4.6";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    pname = "colour_science";
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "027frz8afkixpgsq9d66zr9dwi0r3q1mgni58b1g65hca1nhxnac";
  };

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
