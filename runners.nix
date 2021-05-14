{ lib, target }:

with lib;

# targets -> targetName list of hosts

let
runners = {
  run = foldAttrList (mapAttrsToList (targetName: targetx: mapAttrs' (k: run:
        nameValuePair run.name run.set
   ) targetx.runners.run) target);
  lazy.run = foldAttrList (mapAttrsToList (targetName: targetx: mapAttrs' (k: run:
   nameValuePair run.name run.set
   ) targetx.runners.lazy.run) target);
   lazy.nativeBuildInputs = concatLists (mapAttrsToList (targetName: target: target.runners.lazy.nativeBuildInputs) target);
}; in runners
