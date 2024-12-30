{ config, pkgs, lib, ... }:

let
  commonPlugins = (import ./vim.nix { inherit config pkgs; }).programs.vim.plugins;
in
{
  home.packages = with pkgs; [
    nixd  # LSP for nix files
    ripgrep  # fzf dependency for live_grep

    # patched nerdfont to not include everything
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  programs.neovim = {
    enable = true;
    # defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # telescope
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-file-browser-nvim
      telescope-coc-nvim

      gitsigns-nvim
      nvim-notify

      # status line and stuff
      bufferline-nvim
      nvim-web-devicons
      lualine-nvim
      
      nvim-treesitter
      nvim-treesitter.withAllGrammars
    ] ++ lib.remove vim-airline commonPlugins;  # import other vim plugins from vim.nix

    coc = {
      enable = true;
      settings = {
        # show diagnostics inlined
        "diagnostic.checkCurrentLine" = true;
        "diagnostic.virtualText" = true;
        "diagnostic.virtualTextCurrentLineOnly" = false;
        "diagnostic.refreshOnInsertMode" = true;

        # lsp configs
        languageserver = {
          nix = {
            command = "nixd";
            filetypes = ["nix"];
          };
        };
      };
    };

    extraConfig = builtins.readFile(dotfiles/vimrc);
    extraLuaConfig = builtins.readFile(dotfiles/init.lua);
  };
}
