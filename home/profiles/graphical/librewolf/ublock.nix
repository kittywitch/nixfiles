{nur, ...}: {
  programs.librewolf.profiles.main.extensions = {
    packages = with nur.repos.rycee.firefox-addons; [
      adnauseam
    ];
    settings = {
    };
  };
}
