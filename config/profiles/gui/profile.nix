{ config, meta, ... }: {
  imports = with meta; [
    services.dnscrypt-proxy
  ];
}
