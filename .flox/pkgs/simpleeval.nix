{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "simpleeval";
  version = "1.0.3";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    hash = "sha256-UukPfdo2OKsy2tHDzFY+8njQgNQYb2lf1RGOo8BG17w=";
  };

  pythonImportsCheck = [ "simpleeval" ];

  meta = with lib; {
    description = "A simple, safe single expression evaluator library";
    homepage = "https://github.com/danthedeckie/simpleeval";
    license = licenses.mit;
  };
}
