{
  modulesDir,
  defaultFile ? "default.nix",
  importAll ? false
}:

with builtins;

let
  filterAttrNamesToList = filter: set: foldl' (a: b: a ++ b) [] (
    map (e: if (filter e set.${e}) then [ e ] else []) (attrNames set)
  );
  nameValuePair = name: value: { inherit name value; };
  listToAttrs = foldl' (acc: val: acc // { ${val.name} = val.value; }) {};
  directories = filterAttrNamesToList (_: type: type == "directory") (readDir modulesDir);
  files = map (dir: nameValuePair dir (modulesDir + "/${dir}/${defaultFile}")) directories;
  modules = map ({name, value}:
    # if the file contains a function, assume it to be a module and pass the path
    # (for dedup and such). if it contains anything else, pass that.
    let m = import value; in { inherit name; value = if (isFunction m) && !importAll then value else m; }
  ) files;
in (listToAttrs modules)
