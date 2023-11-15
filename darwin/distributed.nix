{pkgs, ...}: {
  nix.envVars = {
    "SSH_AUTH_SOCK" = "/Users/kat/.gnupg/S.gpg-agent.ssh";
  };

  launchd.daemons.start_nixos_native = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path /nix/store &amp;&amp; ${pkgs.writeScript "start_nixos_native" ''
          /usr/bin/open "utm://start?name=NixOS Native"
        ''}"
      ];
      Label = "org.kittywitch.start_nixos_native";
      RunAtLoad = true;
    };
  };
}
