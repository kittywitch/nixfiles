final: prev: {
  waybar-style = final.callPackage ({ stdenv, sass }: { base16 }:
  stdenv.mkDerivation ({
    pname = "waybar-style";
    version = "0.0.1";

    phases = [ "buildPhase" ];

    src = ./waybar.sass;

    nativeBuildInputs = [
      sass
    ];

    buildPhase = ''
      substituteAll $src waybar-sub.sass
      sass waybar-sub.sass $out --sourcemap=none --style expanded
    '';

    alpha = "80";
  } // base16)) {};
}
