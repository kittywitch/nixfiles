{
  fetchFromGitHub,
  buildDotnetModule,
  lib,
  fontconfig,
  libX11,
  libSM,
  xorg,
  android-tools,
}:
buildDotnetModule rec {
  pname = "QuestPatcher";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "lauriethefish";
    repo = pname;
    rev = version;
    sha256 = "sha256-EubMlYOxoPvwIBS1bxKHob+xaVGNswt7CSCXu/CmUzw=";
  };

  nugetDeps = ./deps.nix;

  runtimeDeps = [
    fontconfig
    libX11
    libSM
    xorg.libICE
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${android-tools}/bin"
  ];

  projectFile = "QuestPatcher/QuestPatcher.csproj";

  meta = with lib; {
    homepage = "https://github.com/Lauriethefish/QuestPatcher";
    description = "Generic il2cpp modding tool for Oculus Quest (1/2) apps.";
    license = licenses.zlib;
    maintainers = with maintainers; [kittywitch];
  };
}
