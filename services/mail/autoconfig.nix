{ pkgs, lib, config, ... }:

let
  commonHeaders = lib.concatStringsSep "\n" (lib.filter (line: lib.hasPrefix "add_header" line) (lib.splitString "\n" config.services.nginx.commonHttpConfig));
in {
  services.nginx.virtualHosts = {
    "autoconfig.kittywit.ch" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "autoconfig.dork.dev"
      ];
      locations = {
        "= /mail/config-v1.1.xml" = {
          root = pkgs.writeTextDir "mail/config-v1.1.xml" ''
            <?xml version="1.0" encoding="UTF-8"?>
            <clientConfig version="1.1">
             <emailProvider id="kittywit.ch">
               <domain>kittywit.ch</domain>
               <displayName>kittywit.ch Mail</displayName>
               <displayShortName>kittywitch</displayShortName>
               <incomingServer type="imap">
                 <hostname>daiyousei.kittywit.ch}</hostname>
                 <port>993</port>
                 <socketType>SSL</socketType>
                 <authentication>password-cleartext</authentication>
                 <username>%EMAILADDRESS%</username>
               </incomingServer>
               <outgoingServer type="smtp">
                 <hostname>daiyousei.kittywit.ch</hostname>
                 <port>465</port>
                 <socketType>SSL</socketType>
                 <authentication>password-cleartext</authentication>
                 <username>%EMAILADDRESS%</username>
               </outgoingServer>
             </emailProvider>
            </clientConfig>
            '';
        };
      };
    };
  };
}
