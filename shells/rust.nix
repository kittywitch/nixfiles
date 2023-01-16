{pkgs, ...}:
with pkgs;
  mkShell {
    nativeBuildInputs = [
      cargo
      rustc
      rustfmt
      rustPackages.clippy
      rust-analyzer
    ];
    RUST_SRC_PATH = rustPlatform.rustLibSrc;
  }
