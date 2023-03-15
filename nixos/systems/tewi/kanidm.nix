{ pkgs, config, tf,... }: let
  conf = import ./snakeoil-certs.nix;
  domain = conf.domain;
  unencryptedCert = with pkgs; runCommand "kanidm-cert" {
    domain = "id.gensokyo.zone";
    nativeBuildInputs = [ minica ];
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
  networks.gensokyo = {
    tcp = [ 8080 636 ];
  };

  services.kanidm =  {
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
      bindaddress = "${config.networks.tailscale.ipv4}:8080";
      ldapbindaddress = "${config.networks.tailscale.ipv4}:636";
      tls_chain = "${unencryptedCert}/${unencryptedCert.domain}.pem";
      tls_key = "${unencryptedCert}/${unencryptedCert.domain}/key.pem";
    };
  };
}
