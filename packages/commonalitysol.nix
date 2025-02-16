{
  lib,
  stdenvNoCC,
  fetchgit,
  openssh,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "commonality-sol";
  version = "0.0.1";

  buildInputs = [
    openssh
  ];

  src = fetchgit {
    url = "https://www.opencode.net/phob1an/commonality.git";
    rev = "0c6b872ff6ca1248f4180fb95fb389b4f9d987bd";
    hash = "sha256-wBsEBd49Go5AuG0DxO+GcXral0D3tDEYtEbxpOpvnMk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{aurorae/themes,plasma/look-and-feel,plasma/themes,Kvantum,sddm/themes,themes,icons,color-schemes,wallpapers,plasma/desktoptheme}
    cp -r themes/Commonality $out/share/aurorae/themes
    cp -r icons/* $out/share/icons
    cp -r Commonality.colors $out/share/color-schemes
    cp -r sddm/themes/Commonality $out/share/sddm/themes
    cp -r look-and-feel/* $out/share/plasma/look-and-feel
    cp -r wallpapers/Commonality $out/share/wallpapers
    cp -r Kvantum/commonality $out/share/Kvantum
    cp -r desktoptheme/* $out/share/plasma/desktoptheme
    cd SOL
    cp -r themes/commonalitysol $out/share/aurorae/themes
    cp -r CommonalitySol.colors $out/share/color-schemes
    cp -r look-and-feel/* $out/share/plasma/look-and-feel
    cp -r sddm/themes/CommonalitySol $out/share/sddm/themes
    cp -r wallpapers/CommonalitySol $out/share/wallpapers
    cp -r Kvantum/commonalitysol $out/share/Kvantum
    cp -r desktoptheme/* $out/share/plasma/desktoptheme

    runHook postInstall
  '';

  meta = with lib; {
    description = "Commonality brings the style of CDE to the Plasma desktop. Its a strongly functional and easily readable design.";
    homepage = "https://www.opencode.net/phob1an/commonality";
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
