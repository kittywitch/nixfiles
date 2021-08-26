{ stdenv, sass, base16 }:

stdenv.mkDerivation ({
  pname = "firefox-tst-css";
  version = "0.0.1";

  phases = [ "buildPhase" ];

  src = ./tst.sass;

  buildInputs = [
    sass
  ];

  buildPhase = ''
    substituteAll $src firefox-tst-substituted.sass
    sass firefox-tst-substituted.sass $out --sourcemap=none
  '';
} // base16)
