{ config, pkgs, ... }:

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
    ];
    extraConfig = builtins.readFile(dotfiles/vimrc);
  };
}
