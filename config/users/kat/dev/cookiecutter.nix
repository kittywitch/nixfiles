{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ cookiecutter ];

  home.shell.functions.katenv = ''
    cookiecutter cookiecutters --directory $1
  '';
}
