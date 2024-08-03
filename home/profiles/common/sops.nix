{parent, ...}: {
  sops = {
    age.sshKeyPaths = [
      "/home/kat/.ssh/id_ed25519"
    ];
    inherit (parent.sops) defaultSopsFile;
  };
}
