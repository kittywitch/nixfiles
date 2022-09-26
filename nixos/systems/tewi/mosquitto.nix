{ config, lib, tf, ... }: {
  networks.gensokyo = {
    tcp = [
      # Mosquitto
      1883
    ];
  };

  kw.secrets.variables.z2m-pass = {
    path = "secrets/mosquitto";
    field = "z2m";
  };

  kw.secrets.variables.systemd-pass = {
    path = "secrets/mosquitto";
    field = "systemd";
  };

  kw.secrets.variables.hass-pass = {
    path = "secrets/mosquitto";
    field = "hass";
  };

  secrets.files.z2m-pass = {
    text = tf.variables.z2m-pass.ref;
    owner = "mosquitto";
    group = "mosquitto";
  };

  secrets.files.systemd-pass = {
    text = tf.variables.systemd-pass.ref;
    owner = "mosquitto";
    group = "mosquitto";
  };

  secrets.files.hass-pass = {
    text = tf.variables.hass-pass.ref;
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
            "readwrite #"
          ];
        };
        systemd = {
          passwordFile = config.secrets.files.systemd-pass.path;
          acl = [
            "readwrite #"
          ];
        };
        hass = {
          passwordFile = config.secrets.files.hass-pass.path;
          acl = [
            "readwrite #"
          ];
        };
      };
      settings = {
        allow_anonymous = false;
      };
    }];
  };
}
