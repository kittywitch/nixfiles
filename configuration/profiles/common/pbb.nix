let
  pbbNixfiles = fetchGit {
    url = "https://git.petabyte.dev/petabyteboy/nixfiles";
    rev = "4b0275db7842fda45dcc007d87b6274c4e63382b";
  };
in {
  imports = [ "${pbbNixfiles}/modules" ];
  nixpkgs.overlays =
    [ (self: super: import "${pbbNixfiles}/pkgs" { nixpkgs = super.path; }) ];
}
