_: {
  services.thelounge = {
    enable = true;
    extraConfig = {
      reverseProxy = true;
      public = false;
      fileUpload = {
        enable = true;
      };
    };
  };
}
