final: prev: {
  requests-oauth = final.python3Packages.callPackage ./requests-oauth.nix {};
  withings-api = final.python3Packages.callPackage ./withings-api.nix {};
  irlsite = final.callPackage ./irlsite.nix {};
  vips = prev.vips.override {libjxl = null;};
  sway-scrot = final.callPackage ./sway-scrot {};
  vfio-vm = final.callPackage ./vm.nix {};
  vfio-vm-pinning = final.callPackage ./vm-pinning.nix {};
  vfio-disk-mapper = final.callPackage ./disk-mapper.nix {};
  xbackbone = final.callPackage ./xbackbone.nix {};
  waybar-gpg = final.callPackage ./waybar-gpg {};
  waybar-konawall = final.callPackage ./waybar-konawall {};
  hedgedoc-cli = final.callPackage ./hedgedoc-cli.nix {};
  gensokyoZone = final.callPackage ./gensokyoZone {};
  kittywitCh = final.callPackage ./gensokyoZone/kittywitch.nix {};
  oomox = final.callPackage ./oomox.nix {};
  wezterm = final.callPackage ./wezterm {
    inherit (final.darwin.apple_sdk.frameworks) Cocoa CoreGraphics Foundation UserNotifications;
  };
  writers = prev.writers.override {
    gixy = final.writeShellScriptBin "gixy" ''
      true
    '';
  };
  terraform-providers =
    prev.terraform-providers
    // {
      tailscale = final.terraform-providers.mkProvider rec {
        owner = "tailscale";
        provider-source-address = "registry.terraform.io/${owner}/${owner}";
        repo = "terraform-provider-tailscale";
        rev = "v${version}";
        hash = "sha256-/qC8TOtoVoBTWeAFpt2TYE8tlYBCCcn/mzVQ/DN51YQ=";
        vendorHash = "sha256-8EIxqKkVO706oejlvN79K8aEZAF5H2vZRdr5vbQa0l4=";
        version = "0.13.5";
      };
    };
}
