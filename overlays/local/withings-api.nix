{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry
, arrow
, requests-oauth
, requests-oauthlib
, typing-extensions
, pydantic
}:

buildPythonPackage rec {
  pname = "withings-api";
  version = "2.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "withings_api"; # source and whl distribution use _ instead of -
    inherit version;
    sha256 = "sha256-vQ6MKeD4g4QTkXx638FW53mTkx78af7NQXF00kxgM10=";
  };

  propagatedBuildInputs = [
    poetry
    arrow
    requests-oauth
    requests-oauthlib
    typing-extensions
    pydantic
  ];

  meta = {
    description = "Library for the Withings Health API";
    homepage = "https://github.com/vangorra/python_withings_api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kittywitch ];
  };
}
