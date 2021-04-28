with (import <nixpkgs> { });

mkShell {
  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
  '';
}
