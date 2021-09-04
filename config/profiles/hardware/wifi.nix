{ config, tf, lib, ... }: with lib;

{
  kw.secrets.variables = mapListToAttrs
    (field:
      nameValuePair "wireless-${field}" {
        path = "secrets/wifi";
        inherit field;
      }) [ "ssid" "password" ];

  deploy.profile.hardware.wifi = true;
  networking.wireless = {
    enable = true;
    networks.${builtins.unsafeDiscardStringContext tf.variables.wireless-ssid.get} = {
      pskRaw = tf.variables.wireless-password.get;
    };
  };
}
