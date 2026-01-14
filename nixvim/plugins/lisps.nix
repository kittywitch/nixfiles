{ std, lib, pkgs, ... }: let
  inherit (lib.attrsets) genAttrs;
  inherit (std) set;
in {
  extraPlugins = with pkgs.vimPlugins; [
    nvim-paredit
  ];
  extraConfigLua = ''
    require("nvim-paredit").setup()
  '';
  lsp.servers = let
    baseServer = {
      enable = true;
      activate = true;
    };
    disablePackage = {
      package = null;
    };
    serversToGen = [
      "fennel-ls"
      "clojure_lsp"
    ];
    disablePackageServers = [
      "clojure_lsp"
    ];
  in set.merge [
    (genAttrs serversToGen (_: baseServer))
    (genAttrs disablePackageServers (_: disablePackage))
  ];
  plugins = let
    pluginsToGen = [
      "conjure"
      "autoclose"
    ];
    basePlugin = {
      enable = true;
      autoLoad = true;
    };
  in
    set.merge [
      (genAttrs pluginsToGen (_: basePlugin))
    ];
}
