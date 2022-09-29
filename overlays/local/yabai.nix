{ lib, stdenv, fetchFromGitHub, darwin, xcbuild, xxd }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5WtWLfiWVOqshbsx50fuEv8ab3U0y6z5+yvXoxpLokU=";
  };

  nativeBuildInputs = [
    darwin.xcode_12_3
    xcbuild
    xxd
  ];

  buildInputs = with darwin.apple_sdk.frameworks; [
    Carbon
    Cocoa
    ScriptingBridge
    SkyLight
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1
  '';

  meta = with lib; {
    description = ''
      A tiling window manager for macOS based on binary space partitioning
    '';
    homepage = "https://github.com/koekeishiya/yabai";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ cmacrae shardy kittywitch ];
    license = licenses.mit;
  };
}
