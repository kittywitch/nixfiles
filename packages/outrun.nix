{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "outrun";
    publisher = "samrapdev";
    version = "0.2.2";
    hash = "sha256-d0LPpUQbz9g9Scv24oS13vQ0X4lA35unRBgRWM+G+5s=";
  };
  meta = {
    description = "A theme for VS Code inspired by the colors, style, and culture of the synthwave music scene.";
    homepage = "https://github.com/samrap/outrun-theme-vscode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=samrapdev.outrun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [pandapip1];
  };
}
