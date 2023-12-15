{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [ Vundle-vim ];
    extraConfig = builtins.readFile(builtins.fetchurl {
      url = "https://gist.githubusercontent.com/laggron42/187570f694da4ae10eb3e5db6cf98205/raw/e95e997edf3580c210231698e63083e00b60b27a/vimrc";
      sha256 = "03pckawnf5494hcwhz3ym00k1p1pryx5c0vj4s6gsw504gi4x227";
    });
  };
}