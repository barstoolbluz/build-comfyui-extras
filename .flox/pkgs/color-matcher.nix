{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "color-matcher";
  version = "0.6.0";
  format = "wheel";

  src = fetchPypi {
    inherit version;
    pname = "color_matcher";
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "0d3pvay2xdfcwaf5hr162hv0h866q640izlnphz7yfy32ja2yr7x";
  };

  dontBuild = true;

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    opencv4
    scikit-image
  ];

  # Skip imports check - opencv dependency issues
  # pythonImportsCheck = [ "color_matcher" ];

  meta = with lib; {
    description = "Color matching algorithms for images";
    homepage = "https://github.com/hahnec/color-matcher";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
