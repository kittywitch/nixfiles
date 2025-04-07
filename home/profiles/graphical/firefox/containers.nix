{ ... }: {
  programs.firefox.profiles.main = {
    containersForce = true;
    containers = {
      main = {
        name = "Primary";
        id = 0;
        color = "turquoise";
        icon = "pet";
      };
      gay = {
        name = "Gay";
        id = 1;
        color = "purple";
        icon = "pet";
      };
      work = {
        name = "Work";
        id = 2;
        color = "pink";
        icon = "briefcase";
      };
      banking = {
        name = "Banking";
        id = 3;
        color = "turquoise";
      };
    };
  };
}

