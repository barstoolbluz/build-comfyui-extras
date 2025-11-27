{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "cstr";
  version = "unstable-2023-05-28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "WASasquatch";
    repo = "cstr";
    rev = "0520c29a18a7a869a6e5983861d6f7a4c86f8e9b";
    sha256 = "1fm22x63ijqszc3a38f7hdfglhbx16pwdkz8b9j5a81v966yf06d";
  };

  pythonImportsCheck = [ "cstr" ];

  meta = with lib; {
    description = "A Python library for colored terminal string formatting";
    homepage = "https://github.com/WASasquatch/cstr";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
