{ config, nixos, pkgs, lib, ... }:
{
  home.file = lib.mkIf config.deploy.profile.trusted (
    let
      bitw = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.kw.secrets.repo.bitw.source} "$@"'';
    in {
      ".local/share/weechat/sec.conf".text = ''
        #
        # weechat -- sec.conf
        #
        # WARNING: It is NOT recommended to edit this file by hand,
        # especially if WeeChat is running.
        #
        # Use /set or similar command to change settings in WeeChat.
        #
        # For more info, see: https://weechat.org/doc/quickstart
        #

        [crypt]
        cipher = aes256
        hash_algo = sha512
        passphrase_command = "bitw get social/irc/weechat -f password"
        salt = on

        [data]
        __passphrase__ = on
        znc = "552E98A5111B986C1003CF86C67DF2AF4B3FDE88E5762FC01EB4A00E31B8363ABFCBBE7A702CB72C298F61D4005D1C5AABB30602BBFCE9E4013CBE88D3D3DB66B18C551743D7816C4F0C9DA44B83DB5807BBB02A48B66D"
        matrix = "CC989DF79CDAECC1CE32F10FA9B42B6AE9FA63B41C0B3FCCCD4A309AB798CDEE695E0B4A2E0C975C6364927C76D4FEB25BC84C7AF8989DC418A205A5D62E9330E142E4F11AB59E0720867915DEEFCA70E80102C639D35B"
      '';
    }
  );

  programs.weechat = {
    enable = true;
    config = {
      irc = {
        server = {
          softnet = {
            address = "athame.kittywit.ch/5001";
            password = "kat@${nixos.networking.hostName}/softnet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          liberachat = {
            address = "athame.kittywit.ch/5001";
            password = "kat@${nixos.networking.hostName}/liberachat:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
          espernet = {
            address = "athame.kittywit.ch/5001";
            password = "kat@${nixos.networking.hostName}/espernet:\${sec.data.znc}";
            ssl = true;
            ssl_verify = false;
            autoconnect = true;
          };
        };
      };
      matrix = {
        server.kittywitch = {
          address = "kittywit.ch";
          device_name = "${nixos.networking.hostName}/weechat";
          username = "kat";
          password = "\${sec.data.matrix}";
        };
      };
    };
  };
}
