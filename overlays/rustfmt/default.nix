final: prev: {
  rustfmt = prev.rustfmt.overrideAttrs ({ patches ? [ ], ... }: {
    patches = patches ++ [
      # Adds an option variant that merges all use statements into a single block.
      # Taken from https://github.com/rust-lang/rustfmt/pull/4680
      ./Implement-One-option-for-imports_granularity-4669.patch
    ];
  });
}
