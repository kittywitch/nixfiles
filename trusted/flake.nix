{
  inputs = {
    trusted = {
      type = "git";
      url = "gcrypt::ssh://git@github.com/arcnmx/kat-nixfiles-trusted.git";
      ref = "shim";
    };
  };
  outputs = { self, trusted, ... }: trusted;
}
