{ config, pkgs, ... }:

{
  users.users.arc = {
    uid = 1001;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8Z6briIboxIdedPGObEWB6QEQkvxKvnMW/UVU9t/ac mew-pgp"
    ];
    shell = pkgs.zsh;
  };  
}
