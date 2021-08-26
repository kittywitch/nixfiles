final: prev: {
  firefox-uc = final.callPackage ({ stdenv, sass }: { base16 }:

  stdenv.mkDerivation ({
    pname = "ff-uc-style";
    version = "0.0.1";

    phases = [ "buildPhase" ];

    src = ./userChrome.sass;

    nativeBuildInputs = [
      sass
    ];

    buildPhase = ''
      substituteAll $src userChrome-sub.sass
      sass userChrome-sub.sass $out --sourcemap=none --style expanded
    '';
  } // base16)) {};
}
