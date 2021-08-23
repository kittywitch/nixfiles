{ config, pkgs, ... }:

{
  xdg.configFile."rustfmt/rustfmt.toml".text = ''
    # SPDX-FileCopyrightText: V <v@anomalous.eu>
    # SPDX-License-Identifier: OSL-3.0

    hard_tabs = true
    imports_granularity = "One"
  '';

  home.packages = with pkgs; [
    rustfmt
  ];
}
