{ lib, notmuch, coreutils }@args:
let
  notmuch = args.notmuch.super or args.notmuch;
  drv = notmuch.override { withEmacs = false; };
in drv.overrideAttrs (old: {
  doCheck = false;

  postInstall = ''
    ${old.postInstall or ""}
    make -C bindings/ruby exec_prefix=$out \
      SHELL=$SHELL \
      $makeFlags ''${makeFlagsArray+"''${makeFlagsArray[@]}"} \
      $installFlags ''${installFlagsArray+"''${installFlagsArray[@]}"} \
      install
    mv $out/lib/ruby/vendor_ruby/* $out/lib/ruby/
    rmdir $out/lib/ruby/vendor_ruby
  '';

  meta = old.meta or { } // {
    broken = old.meta.broken or false || notmuch.stdenv.isDarwin;
  };
  passthru = old.passthru or { } // { super = notmuch; };
})
