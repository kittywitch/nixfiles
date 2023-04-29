{
  pkgs,
  config,
  ...
}: let
  conf = import ./snakeoil-certs.nix;
  domain = conf.domain;
  unencryptedCert = with pkgs;
    runCommand "kanidm-cert" {
      domain = "id.gensokyo.zone";
      nativeBuildInputs = [minica];
    } ''
      install -d $out
      cd $out
      minica \
        --ca-key ca.key.pem \
        --ca-cert ca.cert.pem \
        --domains $domain
      cat $domain/cert.pem ca.cert.pem > $domain.pem
    '';
in {
  networking.firewall.allowedTCPPorts = [
    8081
    636
  ];

  services.kanidm = {
    enableServer = true;
    enablePam = false;
    enableClient = true;
    clientSettings = {
      uri = "https://id.gensokyo.zone";
      verify_ca = true;
      verify_hostnames = true;
    };
    serverSettings = {
      domain = "gensokyo.zone";
      origin = "https://id.gensokyo.zone";
      role = "WriteReplica";
      log_level = "default";
      db_fs_type = "zfs";
      bindaddress = "0.0.0.0:8081";
      ldapbindaddress = "0.0.0.0:636";
      tls_chain = "${unencryptedCert}/${unencryptedCert.domain}.pem";
      tls_key = "${unencryptedCert}/${unencryptedCert.domain}/key.pem";
    };
  };
}
