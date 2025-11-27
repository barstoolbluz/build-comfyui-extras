{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "ffmpy";
  version = "0.5.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "0cq2p2j9nl9is7kdl2b0nrl6fg751rij782r95nsbnhnb37rjdyz";
  };

  dontBuild = true;

  pythonImportsCheck = [ "ffmpy" ];

  meta = with lib; {
    description = "A simple Python wrapper for FFmpeg";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
