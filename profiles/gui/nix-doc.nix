{ pkgs, ... }:

{
  nix.extraOptions = ''
    plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
  '';

  environment.systemPackages = with pkgs; [
    nix-doc
  ];
}
