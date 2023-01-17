{pkgs, ...}:
with pkgs;
  mkShell {
    nativeBuildInputs = [
      jq
      k9s
      terraform
      awscli
    ];
  }
