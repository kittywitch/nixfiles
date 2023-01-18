{
  pkgs,
  inputs,
  std,
  ...
}:
with pkgs; let
  repo = import ../outputs.nix { inherit inputs; };
  inherit (std) set list;
  python = "python39";
  mergeEnvs = envs:
    pkgs.mkShell (list.foldl'
      (a: v: {
        buildInputs = a.buildInputs ++ v.buildInputs;
        nativeBuildInputs = a.nativeBuildInputs ++ v.nativeBuildInputs;
      })
      (pkgs.mkShell { })
      envs);
  requirements = builtins.readFile ../requirements.txt;
  mach-nix-wrapper = import inputs.mach-nix { inherit pkgs python; };
  pythonShell = mach-nix-wrapper.mkPythonShell { inherit requirements; };
  repoShell = mkShell {
    nativeBuildInputs =
      [
        go # Required for pulumi
        pulumi # Infrastructure as code
        python39Packages.pulumi # Pulumi for Python!
        pulumiPackages.pulumi-language-python # Python!
        deadnix # dead-code scanner
        alejandra # code formatter
        statix # anti-pattern finder
      ]
      ++ set.values (set.map (name: _: (pkgs.writeShellScriptBin "${name}-rebuild" ''
        darwin-rebuild switch --flake $REPO_ROOT#${name}
      ''))
      repo.darwinConfigurations);
  };
in mergeEnvs [ repoShell pythonShell ]
