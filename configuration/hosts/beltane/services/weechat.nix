{ config, pkgs, ... }:

{
    services.weechat = {
      binary = let new-weechat = pkgs.wrapWeechat pkgs.weechat-unwrapped { 
        configure = { availablePlugins, ... }: { 
            scripts = [ pkgs.weechatScripts.weechat-matrix ]; 
            plugins = [ availablePlugins.perl ( availablePlugins.python.withPackages (ps: [ ps.potr pkgs.weechatScripts.weechat-matrix ])) ]; }; 
        }; in "${new-weechat}/bin/weechat";
      enable = true;
    };

    programs.screen.screenrc = ''
        multiuser on
        acladd kat
    '';
}