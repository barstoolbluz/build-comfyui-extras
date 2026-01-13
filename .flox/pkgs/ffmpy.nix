{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "ffmpy";
  version = "1.0.0";
  format = "wheel";

  # Use vendored source for reproducibility
  src = ../../sources/ffmpy-1.0.0-py3-none-any.whl;

  dontBuild = true;

  pythonImportsCheck = [ "ffmpy" ];

  meta = with lib; {
    description = "A simple Python wrapper for FFmpeg";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
