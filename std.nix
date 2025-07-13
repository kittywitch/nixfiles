{inputs, ...}: let
  std = let
    baseStd = inputs.std.lib.Std.compat // { inherit (inputs.std.lib.Std.std) tuple; };
    inherit (baseStd) set function list bool types optional tuple;
    mergeWith = let
      append = {
        path,
        values,
        canMerge,
        mapToSet,
      }: let
        mergeWith' = values:
          mergeWith {
            inherit canMerge mapToSet path;
            sets = list.map (v: (mapToSet path v).value) values;
          };
        mergeUntil = list.findIndex (function.not (canMerge path)) values;
        len = list.length values;
      in
        if len == 0
        then {}
        else if len == 1
        then list.unsafeHead values
        else if list.all (canMerge path) values
        then mergeWith' values
        else
          optional.match mergeUntil {
            just = i: let
              split = list.splitAt i values;
            in
              if i > 0
              then mergeWith' split._0
              else list.unsafeHead values;
            nothing = list.unsafeHead values;
          };
    in
      {
        canMerge ? path: v: optional.isJust (mapToSet path v),
        mapToSet ? _: v: bool.toOptional (types.attrs.check v) v,
        path ? [],
        sets,
      }:
        set.mapZip (name: values:
          append {
            path = path ++ list.One name;
            inherit canMerge mapToSet values;
          })
        sets;
    merge = sets:
      mergeWith {
        inherit sets;
      };
    remap = f: s: set.fromList (list.map f (set.toList s));
    renames = names:
      remap ({
        _0,
        _1,
      }:
        tuple.tuple2 (names.${_0} or _0) _1);
    rename = oldName: newName: renames {${oldName} = newName;};
  in
    merge [
      baseStd
      {
        function = {
          pipe = list.foldl' (function.flip function.compose) function.id;
        };
        set = {
          inherit merge mergeWith remap renames rename;
          recursiveMap = f: s: let
            recurse = str: s: let
              g = str1: str2:
                if types.attrs.check str2
                then f (str ++ [str1]) (recurse (str ++ [str1]) str2)
                else f (str ++ [str1]) str2;
            in
              set.map g s;
          in
            f [] (recurse [] s);
        };
      }
    ];
in
  std
