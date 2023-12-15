{ config, pkgs, ... }:

{
  home.username = "laggron";
  home.homeDirectory = "/Users/laggron";
  home.stateVersion = "23.05";

  programs.home-manager = {
    enable = true;
    path = "$HOME/nix-laggron";
  };

  imports = [
    ./gnupg.nix
    ./git.nix
    ./vim.nix
    ./zsh.nix
  ];
}
