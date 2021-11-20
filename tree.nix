{ lib }: { config, folder, sources, ... }@args: with lib; let
  pureTreeGrab = { base, path }: let
    realPath = toString path;
    dirContents = builtins.readDir path;
    isDirectory = entry: dirContents."${entry}" == "directory";
    isHidden = entry: hasPrefix "." entry;
    isDir = entry: _: (isDirectory entry) && !(isHidden entry);
    directories = filterAttrs isDir dirContents;
    isNixFile = entry: _: let
      result = builtins.match "(.*)\\.nix" entry;
    in result != null && builtins.length result > 0;
    nixFiles = filterAttrs isNixFile dirContents;
    getPath = entry: "${realPath}/${entry}";
    getPaths = entries: mapAttrs' (n: v:
      nameValuePair (removeSuffix ".nix" n) (getPath n)
    ) entries;
    nixFilePaths = getPaths nixFiles;
    dirPaths = getPaths directories;
    recursedPaths = mapAttrs (_: fullPath: pureTreeGrab {
      inherit base;
      path = fullPath;
    }) dirPaths;
    contents = recursedPaths // nixFilePaths;
 in contents;
  configTreeStruct = { config, ... }: {
    options.treeConfig = mkOption {
      type = with types; attrsOf (submodule ({ name, options, config, ... }: {
        options = {
          evaluateDefault = mkOption {
            type = types.bool;
            description = "Replace the contents of this branch or leaf with those provided by the evaluation of default.nix.";
            default = false;
          };
          aliasDefault = mkOption {
            type = types.bool;
            description = "Replace the contents of this branch or leaf with the default.nix.";
            default = false;
          };
          excludes = mkOption {
            type = types.listOf types.str;
            description = "Exclude files or folders from the recurser.";
            default = [];
          };
          functor = {
            enable = mkOption {
              type = types.bool;
              description = "Provide a functor for the path provided";
              default = false;
            };
            external = mkOption {
              type = types.listOf types.unspecified;
              description = "Add external imports into the functor.";
              default = [];
            };
            excludes = mkOption {
              type = types.listOf types.str;
              description = "Exclude files or folders from the functor.";
              default = [];
            };
          };
        };
      }));
    };
    config.treeConfig = {
      "*" = {};
    };
  };
  configTree.treeConfig = config;
  configTreeModule = (evalModules {
    modules = [
      configTreeStruct
      configTree
    ];
  }).config.treeConfig;
  mapAttrsRecursive = f: set: let
    recurse = path: set: let
      g = name: value: if isAttrs value
        then f (path ++ [name]) (recurse (path ++ [name]) value)
        else f (path ++ [name]) value;
    in mapAttrs g set;
  in recurse [] set;
  getPathString = path: concatStringsSep "/" path;
  getConfig = path: default: configTreeModule.${getPathString path} or default;
  revtail = path: sublist 0 (length path - 1) path;
  getConfigRecursive = path: let
    parentPath = revtail path;
  in getConfig (path ++ singleton "*") (getConfigRecursive parentPath);
  processLeaves = tree: config: mapAttrsRecursive (path: value: let
    pathString = getPathString path;
    leafConfig = getConfig path (getConfigRecursive (revtail path));
    processConfig = path: value: let
      processFunctor = prev: prev // {
        __functor = self: { ... }: {
          imports = attrValues (removeAttrs prev leafConfig.functor.excludes) ++ leafConfig.functor.external;
        };
      };
      processAliasDefault = prev: prev.default;
      processDefault = prev: import prev.default (args // {
        inherit lib;
        tree = {
          prev = removeAttrs prev (singleton "default");
          pure = pureTree;
          impure = impureTree;
        };
      });
      processExcludes = prev: removeAttrs prev leafConfig.excludes;
      processes = optionals (isAttrs value) (
        optional (leafConfig.excludes != []) processExcludes
        ++ optional leafConfig.evaluateDefault processDefault
        ++ optional leafConfig.aliasDefault processAliasDefault
        ++ optional leafConfig.functor.enable processFunctor
      );
    in pipe value processes;
  in processConfig path value) tree;
  pureTree = pureTreeGrab { base = folder; path = folder; };
  impureTree = processLeaves pureTree configTreeModule;
in {
  config = configTreeModule;
  pure = pureTree;
  impure = impureTree;
}
