{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #ida-pro-kat
    #android-studio
    bingrep
    hexyl
    jwt-cli
    silicon
    tokei
    clojure
    clojure-lsp
    babashka
    clj-kondo
    polylith
    leiningen
    neil
    jet
  ];
}
