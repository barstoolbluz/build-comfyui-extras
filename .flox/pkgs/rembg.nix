{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.68";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    abi = "none";
    platform = "any";
    sha256 = "12xjaq0m5ddbdbzcgdpj15rfqvk9vicyinnjs3c3frl21d237qs1";
  };

  dontBuild = true;

  propagatedBuildInputs = with python3.pkgs; [
    onnxruntime
    pillow
    numpy
    opencv4
    scikit-image
    aiohttp
    asyncer
    click
    filetype
    imagehash
    pooch
    pymatting
    tqdm
  ];

  # Skip imports check - many optional dependencies
  # pythonImportsCheck = [ "rembg" ];

  meta = with lib; {
    description = "Remove image backgrounds using machine learning";
    homepage = "https://github.com/danielgatis/rembg";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
