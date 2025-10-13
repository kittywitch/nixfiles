{channels, ...}: {
  bootstrap.packages.nix = channels.nixpkgs.lixPackageSets.stable.lix;
  nixpkgs.args = {
    localSystem = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };

  ci = {
    version = "v0.7";
    gh-actions = {
      enable = true;
    };
  };

  nix.config = {
    max-silent-time = 60 * 60;
    build-users-group = "";
  };
  /*
    nix.config = {
    extra-platforms = ["aarch64-linux" "armv6l-linux" "armv7l-linux"];
    #extra-sandbox-paths = with channels.cipkgs; map (package: builtins.unsafeDiscardStringContext "${package}?") [bash qemu "/run/binfmt"];
  };
  */

  channels = {
    nixfiles.path = ../.;
    std.path = "${channels.nixfiles.inputs.std}";
    nixpkgs.path = "${channels.nixfiles.inputs.nixpkgs}";
  };

  ci.gh-actions.checkoutOptions = {
    submodules = false;
  };

  cache.cachix = {
    arc = {
      enable = true;
      publicKey = "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=";
      signingKey = null;
    };
    nix-community = {
      enable = true;
      publicKey = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      signingKey = null;
    };
    nix-gaming = {
      enable = true;
      publicKey = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
      signingKey = null;
    };
    niri = {
      enable = true;
      publicKey = "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=";
      signingKey = null;
    };
    chaotic-nyx = {
      enable = true;
      publicKey = "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=";
      signingKey = null;
    };
    kittywitch = {
      enable = true;
      publicKey = "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=";
      signingKey = "mewp";
    };
  };
}
