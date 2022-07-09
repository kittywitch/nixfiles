{ config, lib, pkgs, ... }:

with lib;

let
  dkimUser = config.services.opendkim.user;
  dkimGroup = config.services.opendkim.group;
  dkimKeyDirectory = "/var/dkim";
  dkimKeyBits = 1024;
  dkimSelector = "mail";
  domains = [ "kittywit.ch" "dork.dev" ];

  createDomainDkimCert = dom:
    let
      dkim_key = "${dkimKeyDirectory}/${dom}.${dkimSelector}.key";
      dkim_txt = "${dkimKeyDirectory}/${dom}.${dkimSelector}.txt";
    in
        ''
          if [ ! -f "${dkim_key}" ] || [ ! -f "${dkim_txt}" ]
          then
              ${pkgs.opendkim}/bin/opendkim-genkey -s "${dkimSelector}" \
                                                   -d "${dom}" \
                                                   --bits="${toString dkimKeyBits}" \
                                                   --directory="${dkimKeyDirectory}"
              mv "${dkimKeyDirectory}/${dkimSelector}.private" "${dkim_key}"
              mv "${dkimKeyDirectory}/${dkimSelector}.txt" "${dkim_txt}"
              echo "Generated key for domain ${dom} selector ${dkimSelector}"
          fi
        '';
  createAllCerts = lib.concatStringsSep "\n" (map createDomainDkimCert domains);

  keyTable = pkgs.writeText "opendkim-KeyTable"
    (lib.concatStringsSep "\n" (lib.flip map domains
      (dom: "${dom} ${dom}:${dkimSelector}:${dkimKeyDirectory}/${dom}.${dkimSelector}.key")));
  signingTable = pkgs.writeText "opendkim-SigningTable"
    (lib.concatStringsSep "\n" (lib.flip map domains (dom: "${dom} ${dom}")));

  dkim = config.services.opendkim;
  args = [ "-f" "-l" ] ++ lib.optionals (dkim.configFile != null) [ "-x" dkim.configFile ];
in
{
    config = {
      services.opendkim = {
        enable = true;
        selector = dkimSelector;
        keyPath = dkimKeyDirectory;
        domains = "csl:${builtins.concatStringsSep "," domains}";
        configFile = pkgs.writeText "opendkim.conf" (''
          Canonicalization relaxed/simple
          UMask 0002
          Socket ${dkim.socket}
          KeyTable file:${keyTable}
          SigningTable file:${signingTable}
        '');
      };

      users.users = optionalAttrs (config.services.postfix.user == "postfix") {
        postfix.extraGroups = [ "${dkimGroup}" ];
      };
      systemd.services.opendkim = {
        preStart = lib.mkForce createAllCerts;
        serviceConfig = {
          ExecStart = lib.mkForce "${pkgs.opendkim}/bin/opendkim ${escapeShellArgs args}";
          PermissionsStartOnly = lib.mkForce false;
        };
      };
      systemd.tmpfiles.rules = [
        "d '${dkimKeyDirectory}' - ${dkimUser} ${dkimGroup} - -"
      ];
    };
}
