{ lib, inputs,  ... }: with lib; {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    age.sshKeyPaths = mkDefault [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
