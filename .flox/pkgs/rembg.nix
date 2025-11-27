{ lib, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.68";
  format = "wheel";

  # Use vendored source for reproducibility
  src = ../../sources/rembg-2.0.68-py3-none-any.whl;

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
