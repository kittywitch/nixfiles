_: {
  services.prosody = {
    enable = true;
    ssl.cert = "/var/lib/prosody/xmpp-fullchain.pem";
    ssl.key = "/var/lib/prosody/xmpp-key.pem";
    admins = ["kat@kittywit.ch"];
    muc = [{domain = "conference.kittywit.ch";}];
    virtualHosts."kittywit.ch" = {
      enabled = true;
      domain = "kittywit.ch";
      ssl.cert = "/var/lib/prosody/xmpp-fullchain.pem";
      ssl.key = "/var/lib/prosody/xmpp-key.pem";
    };
    httpPorts = [5280];
    httpFileShare = {
      domain = "upload.xmpp.kittywit.ch";
    };
  };

  security.acme.certs."kittywit.ch" = {
    postRun = ''
      cp key.pem /var/lib/prosody/xmpp-key.pem
      chown prosody:prosody /var/lib/prosody/xmpp-key.pem
      cp fullchain.pem /var/lib/prosody/xmpp-fullchain.pem
      chown prosody:prosody /var/lib/prosody/xmpp-fullchain.pem
      systemctl reload prosody
    '';
  };

  services.nginx.virtualHosts."upload.xmpp.kittywit.ch" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:5280";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    5222
    5223
    5269
  ];
}
