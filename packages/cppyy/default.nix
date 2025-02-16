{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  setuptools,
  python,
}: let
  cppyy = python.buildPythonPackage rec {
    pname = "cppyy";
    version = "3.5.0";

    src = fetchFromGitHub {
      owner = "wlav";
      repo = pname;
      rev = version;
      sha256 = lib.fakeSha256;
    };

    pythonImportsCheck = ["cppyy" "test"];

    meta = with lib; {
      homepage = "https://github.com/wlav/cppyy";
      description = "Python C++ bindings interface based on Cling/LLVM";
      license = licenses.bsd3Lbnl;
    };
  };
in cppyy