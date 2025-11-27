{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "piexif";
  version = "1.1.3";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py2.py3";
    abi = "none";
    platform = "any";
    hash = "sha256-OjvCLCbP/w6E0yt+TcRi0HwJGmHfg5cO5FHn0qjGvFU=";
  };

  pythonImportsCheck = [ "piexif" ];

  meta = with lib; {
    description = "Simplify EXIF manipulations with Python";
    homepage = "https://github.com/hMatoba/Piexif";
    license = licenses.mit;
  };
}
