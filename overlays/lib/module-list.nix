{ lib }: { modulesDir, defaultFile ? "default.nix", importAll ? false }:

with builtins;

let
  isModule = m: lib.isFunction m && (m.isModule or true);
  filterAttrNamesToList = filter: set:
    foldl' (a: b: a ++ b) [ ]
      (map (e: if (filter e set.${e}) then [ e ] else [ ]) (attrNames set));
  nameValuePair = name: value: { inherit name value; };
  listToAttrs = foldl' (acc: val: acc // { ${val.name} = val.value; }) { };
  directories =
    filterAttrNamesToList (_: type: type == "directory") (readDir modulesDir);
  files = map (dir: nameValuePair dir (modulesDir + "/${dir}/${defaultFile}"))
    (filter (f: builtins.pathExists (modulesDir + "/${f}/${defaultFile}")) directories);
  modules = map
    ({ name, value }:
      # if the file contains a function, assume it to be a module and pass the path
      # (for dedup and such). if it contains anything else, pass that.
      let m = import value;
      in
      {
        inherit name;
        value = if lib.isFunction m && ! isModule m then m { inherit lib; } else if isModule m && !importAll then value else m;
      })
    files;
  modList = (listToAttrs modules);
in
modList
