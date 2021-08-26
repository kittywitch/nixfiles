{ sources }: final: prev: {
  nur = import sources.nur {
    nurpkgs = final;
    pkgs = final;
  };
}
