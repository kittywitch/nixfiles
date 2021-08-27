{ stdenv, wrapShellScriptBin, pkgs }:

let
  toggle = wrapShellScriptBin "konawall-toggle" ./toggle.sh { };
  status = wrapShellScriptBin "konawall-status" ./status.sh { };
in
stdenv.mkDerivation {
  pname = "konawall-toggle";
  version = "0.0.1";
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${status}/bin/konawall-status $out/bin/konawall-status
    cp ${toggle}/bin/konawall-toggle $out/bin/konawall-toggle
    chmod +x $out/bin/konawall-{status,toggle}
  '';
}
