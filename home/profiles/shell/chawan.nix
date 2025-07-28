_: {
  programs.chawan = {
    enable = true;
    settings = {
      buffer = {
        images = true;
        autofocus = true;
      };
      pager."C-k" = "() => pager.load('https://duckduckgo.com/?=')";
      pager."C-l" = "() => pager.load('https://github.com/?=')";
      pager."C-m" = "() => pager.load('https://news.ycombinator.com/?=')";
    };
  };
}
