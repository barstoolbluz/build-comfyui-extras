{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "img2texture";
  version = "unstable-2024-02-20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "WASasquatch";
    repo = "img2texture";
    rev = "d6159abea44a0b2cf77454d3d46962c8b21eb9d3";
    sha256 = "0kpirm765wrr06znb0h547wf8njm2k3jf0fmkssiryp037srxjg7";
  };

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    pillow
  ];

  pythonImportsCheck = [ "img2texture" ];

  meta = with lib; {
    description = "Convert images to seamless textures";
    homepage = "https://github.com/WASasquatch/img2texture";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
