{
  dino-omemo = { dino, ... }: dino.overrideAttrs ({ patches ? [ ], ... }: {
    patches = patches ++ [
      ./dino/0001-add-an-option-to-enable-omemo-by-default-in-new-conv.patch
    ];
  });
  obs-studio-pipewire = { obs-studio, ... }: obs-studio.override { pipewireSupport = true; };
  konawall-sway = { arc, ... }: arc.packages.personal.konawall.override { swaySupport = true; };
  ncmpcpp-kat = { ncmpcpp, ... }: ncmpcpp.override {
    visualizerSupport = true;
    clockSupport = true;
  };
  discord-nssfix = { discord, nss, ... }: discord.override { inherit nss; };
  element-wayland = { element-desktop, ... }: element-desktop.override { useWayland = true; };
}
