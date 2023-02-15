{pkgs, ...}:
with pkgs;
  mkShell {
    nativeBuildInputs = [
      jq
      ripgrep
      kubectl
      k9s
      terraform
      awscli
    ];
  }
