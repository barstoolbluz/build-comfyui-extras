{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "img2texture";
  version = "1.0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "WASasquatch";
    repo = "img2texture";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # TODO: get actual hash
  };

  pythonImportsCheck = [ "img2texture" ];

  meta = with lib; {
    description = "Texture generation from images";
    homepage = "https://github.com/WASasquatch/img2texture";
    license = licenses.mit;
    platforms = platforms.unix;  # Linux + macOS
  };
}
