{ config, lib, tf, ... }: {
  kw.secrets.variables.z2m-pass = {
    path = "secrets/mosquitto";
    field = "z2m";
  };

  secrets.files.z2m-pass = {
    text = tf.variables.z2m-pass.ref;
    owner = "mosquitto";
    group = "mosquitto";
  };

  services.mosquitto = {
    enable = true;
    persistence = true;
    listeners = [{
      acl = [
        "pattern readwrite #"
      ];
      users = {
        z2m = {
          passwordFile = config.secrets.files.z2m-pass.path;
          acl = [
            "topic readwrite zigbee2mqtt/#"
          ];
        };
      };
      settings = {
        allow_anonymous = false;
      };
    }];
  };
}
