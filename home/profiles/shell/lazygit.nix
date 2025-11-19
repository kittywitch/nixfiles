_: {
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        overrideGpg = true;
        pagers = [
          {pager = "delta --paging=never";}
        ];
      };
    };
  };
}
