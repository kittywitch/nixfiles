{ config, meta, inputs, lib, pkgs, ... }:

{
 imports = lib.optional (meta.trusted ? secrets) meta.trusted.secrets;
}
