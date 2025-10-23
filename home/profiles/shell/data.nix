{pkgs, ...}: {
  programs.jq = {
    enable = true;
  };
  programs.jqp = {
    enable = true;
  };
  home.packages = with pkgs; [
    htmlq # JQ for HTML
    gron # Make JSON greppable
    jless # Command-line JSON viewer
    jo # Interface for creating JSON objects in shell
    jc # Turn output of common/popular packages into JSON
    dasel # JSON, YAML, TOML, XML, and CSV multitool
    yj # Convert between YAML, TOML, JSON, and HCL. Preserves map order.
    csview # CSV viewer
    glow # Markdown viewer
  ];
}
