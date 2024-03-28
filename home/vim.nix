{ config, pkgs, ... }:

let
  tiger-vim = pkgs.vimUtils.buildVimPlugin {
    name = "tiger-vim";
    src = pkgs.fetchFromGitHub {
      owner = "BarrensZeppelin";
      repo = "tiger.vim";
      rev = "419d1823f117df3b184e4358feb3247a6bdc1f5a";
      sha256 = "138r6fsgm5vy0v4882kvg2is0ajswm8qahhfzyhshnhgqa68yxas";
    };
  };
in
{
  home.packages = with pkgs; [
    nodejs
  ];


  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # themes
      vim-code-dark
      vim-airline

      # LSP
      coc-nvim
      coc-sh
      coc-clangd
      coc-yaml
      coc-json
      coc-vimlsp
      coc-pyright
      coc-cmake

      # tools
      DoxygenToolkit-vim
      tiger-vim
    ];
    extraConfig = builtins.readFile(dotfiles/vimrc);
  };
}
