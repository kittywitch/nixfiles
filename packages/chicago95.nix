{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gdk-pixbuf,
  xfce,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "chicago95";
  version = "3.0.1";

  buildInputs = [gdk-pixbuf xfce.xfce4-panel-profiles];

  src = fetchFromGitHub {
    owner = "grassmunk";
    repo = "Chicago95";
    rev = "v${version}";
    hash = "sha256-EHcDIct2VeTsjbQWnKB2kwSFNb97dxuydAu+i/VquBA=";
  };

  # the Makefile is just for maintainers
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{themes,icons,sounds}
    cp -r Theme/Chicago95 $out/share/themes
    cp -r Icons/* $out/share/icons
    cp -r Cursors/* $out/share/icons
    cp -r sounds/Chicago95 $out/share/sounds

    runHook postInstall
  '';

  meta = with lib; {
    description = "A rendition of everyone's favorite 1995 Microsoft operating system for Linux.";
    homepage = "https://github.com/grassmunk/Chicago95";
    license = with licenses; [gpl3Plus mit];
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
