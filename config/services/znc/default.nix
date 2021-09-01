{ config, tf, lib, pkgs, ... }:

with lib;

let
  sortedAttrs = set: sort
    (l: r:
      if l == "extraConfig" then false # Always put extraConfig last
      else if isAttrs set.${l} == isAttrs set.${r} then l < r
      else isAttrs set.${r} # Attrsets should be last, makes for a nice config
      # This last case occurs when any side (but not both) is an attrset
      # The order of these is correct when the attrset is on the right
      # which we're just returning
    )
    (attrNames set);

  # Specifies an attrset that encodes the value according to its type
  encode = name: value: {
    null = [ ];
    bool = [ "${name} = ${boolToString value}" ];
    int = [ "${name} = ${toString value}" ];

    # extraConfig should be inserted verbatim
    string = [ (if name == "extraConfig" then value else "${name} = ${value}") ];

    # Values like `Foo = [ "bar" "baz" ];` should be transformed into
    #   Foo=bar
    #   Foo=baz
    list = concatMap (encode name) value;

    # Values like `Foo = { bar = { Baz = "baz"; Qux = "qux"; Florps = null; }; };` should be transmed into
    #   <Foo bar>
    #     Baz=baz
    #     Qux=qux
    #   </Foo>
    set = concatMap
      (subname: optionals (value.${subname} != null) ([
        "<${name} ${subname}>"
      ] ++ map (line: "\t${line}") (toLines value.${subname}) ++ [
        "</${name}>"
      ]))
      (filter (v: v != null) (attrNames value));

  }.${builtins.typeOf value};

  # One level "above" encode, acts upon a set and uses encode on each name,value pair
  toLines = set: concatMap (name: encode name set.${name}) (sortedAttrs set);

in
{
  network.firewall.public.tcp.ports = singleton 5001;

  kw.secrets.variables = let
    fieldAdapt = field: if field == "cert" then "notes" else if field == "pass" then "password" else field;
  in listToAttrs (concatMap (network:
    map (field:
      nameValuePair "znc-${network}-${field}" {
        path = "social/irc/${network}";
        field = fieldAdapt field;
    }) ["cert" "pass"]
  ) ["liberachat" "espernet"]
  ++ map (field:
      nameValuePair "znc-softnet-${field}" {
        path = "social/irc/softnet";
        field = fieldAdapt field;
    }) ["cert" "address"]
   ++ singleton (nameValuePair "znc-savebuff-pass" {
      path = "social/irc/znc";
      field = "savebuff";
    })
  );

  secrets.files.softnet-cert = {
    text = tf.variables.znc-softnet-cert.ref;
    owner = "znc";
    group = "znc";
  };

  secrets.files.espernet-cert = {
    text = tf.variables.znc-espernet-cert.ref;
    owner = "znc";
    group = "znc";
  };

  secrets.files.liberachat-cert = {
    text = tf.variables.znc-liberachat-cert.ref;
    owner = "znc";
    group = "znc";
  };

  system.activationScripts = {
    softnet-cert-deploy = {
      text = ''
        mkdir -p /var/lib/znc/users/kat/networks/softnet/moddata/cert
        ln -fs ${config.secrets.files.softnet-cert.path} /var/lib/znc/users/kat/networks/softnet/moddata/cert/user.pem
      '';
    };
    esperrnet-cert-deploy = {
      text = ''
        mkdir -p /var/lib/znc/users/kat/networks/espernet/moddata/cert
        ln -fs ${config.secrets.files.espernet-cert.path} /var/lib/znc/users/kat/networks/espernet/moddata/cert/user.pem
      '';
    };
    liberachat-cert-deploy = {
      text = ''
        mkdir -p /var/lib/znc/users/kat/networks/liberachat/moddata/cert
        ln -fs ${config.secrets.files.liberachat-cert.path} /var/lib/znc/users/kat/networks/liberachat/moddata/cert/user.pem
      '';
    };
  };

  secrets.files.znc-config = {
    text = concatStringsSep "\n" (toLines config.services.znc.config);
    owner = "znc";
    group = "znc";
  };

  services.nginx.virtualHosts."znc.${config.network.dns.domain}" = {
    enableACME = true;
    forceSSL = true;
    locations = { "/".proxyPass = "http://127.0.0.1:5002"; };
  };

  deploy.tf.dns.records.services_znc = {
    inherit (config.network.dns) zone;
    domain = "znc";
    cname = { inherit (config.network.addresses.public) target; };
  };

  services.znc = {
    enable = true;
    mutable = false;
    useLegacyConfig = false;
    openFirewall = false;
    modulePackages = with pkgs.zncModules; [
      clientbuffer
      clientaway
      playback
      privmsg
    ];
    config = lib.mkMerge [
      ({
        Version = lib.getVersion pkgs.znc;
        Listener.l = {
          Port = 5002;
          SSL = false;
          AllowWeb = true;
        };
        Listener.j = {
          Port = 5001;
          SSL = true;
          AllowWeb = false;
        };
        LoadModule = [ "webadmin" "adminlog" "playback" "privmsg" ];
        User = {
          kat = {
            Admin = true;
            Nick = "kat";
            AltNick = "katrin";
            AutoClearChanBuffer = false;
            AutoClearQueryBuffer = false;
            LoadModule = [ "clientbuffer autoadd" "buffextras" "clientaway" "savebuff ${tf.variables.znc-savebuff-pass.ref}" ];
            Network.softnet = {
              Server = "${tf.variables.znc-softnet-address.ref}";
              Nick = "kat";
              AltNick = "kat_";
              JoinDelay = 2;
              LoadModule = [ "simple_away" "cert" ];
            };
            Network.liberachat = {
              Server = "irc.libera.chat +6697 ${tf.variables.znc-liberachat-pass.ref}";
              Nick = "kat";
              AltNick = "kat_";
              JoinDelay = 2;
              LoadModule = [ "cert" "simple_away" "nickserv" ];
            };
            Network.espernet = {
              Server = "anarchy.esper.net +6697 ${tf.variables.znc-espernet-pass.ref}";
              Nick = "kat";
              AltNick = "katrin";
              JoinDelay = 2;
              LoadModule = [ "simple_away" "nickserv" "cert" ];
            };
          };
        };
      })
      (mkIf config.deploy.profile.trusted (import config.kw.secrets.repo.znc.source))
    ];
    configFile = config.secrets.files.znc-config.path;
  };
}
