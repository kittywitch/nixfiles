{ lib, stdenv, fetchurl, python36, pythonPackages, installShellFiles }:

stdenv.mkDerivation {
  name = "kat-weather";
  buildInputs = [
    (python36.withPackages (pythonPackages: with pythonPackages; [
      requests
    ]))
  ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${./weather.py} $out/bin/kat-weather
    chmod +x $out/bin/kat-weather
  '';
}