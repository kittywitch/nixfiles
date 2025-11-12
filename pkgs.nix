{
  tree,
  inputs,
  ...
}: let
  overlays = import tree.overlays {inherit inputs tree;};
in
  inputs.flake-utils.lib.eachDefaultSystem (system: {
    pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
        permittedInsecurePackages = [
          "olm-3.2.16"
          "mbedtls-2.28.10"
        ];
      };
    };
  })
