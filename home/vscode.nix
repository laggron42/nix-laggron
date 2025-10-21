{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscode-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      eamodio.gitlens
      mhutchie.git-graph
      donjayamanne.githistory
      pkief.material-icon-theme
      gruntfuggly.todo-tree
      redhat.vscode-yaml
      ms-vscode.live-server
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vite";
        publisher = "antfu";
        version = "0.2.5";
        sha256 = "14f910il7q5nqrihncwi2x6dlaji139cr3y36cxv2p4bhsm9lyqp";
      }
    ];
  };
}
