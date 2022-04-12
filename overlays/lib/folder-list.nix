{ lib }: path: excludes:
let
  filterAttrNamesToList = filter: set:
    lib.foldl' (a: b: a ++ b) [ ]
      (map (e: if (filter e set.${e}) then [ e ] else [ ]) (lib.attrNames set));
in
(filterAttrNamesToList (name: type: ! (builtins.elem name excludes) && type == "directory") (builtins.readDir path))
