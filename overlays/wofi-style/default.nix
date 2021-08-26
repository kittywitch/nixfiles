final: prev: {
  wofi-style = final.callPackage ({ stdenv, sass }: { base16 }:
  stdenv.mkDerivation ({
    pname = "wofi-style";
    version = "0.0.1";

    phases = [ "buildPhase" ];

    src = ./wofi.sass;

    nativeBuildInputs = [
      sass
    ];

    buildPhase = ''
      substituteAll $src wofi-sub.sass
      sass wofi-sub.sass $out --sourcemap=none --style expanded
    '';

    alpha = "80";
  } // base16)) {};
}
