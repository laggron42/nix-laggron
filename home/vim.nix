{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-code-dark
      vim-airline
      coc-nvim
      coc-sh
      coc-clangd
      coc-yaml
      coc-json
      coc-vimlsp
      coc-pyright
      DoxygenToolkit-vim
    ];
    extraConfig = builtins.readFile(dotfiles/vimrc);
  };
}
