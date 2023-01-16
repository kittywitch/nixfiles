{pkgs, ...}:
with pkgs;
  mkShell {
    nativeBuildInputs = [
      deadnix # dead-code scanner
      alejandra # code formatter
      statix # anti-pattern finder
    ];
  }
