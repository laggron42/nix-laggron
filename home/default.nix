{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  programs.home-manager = {
    enable = true;
    #path = "$HOME/nix-laggron";
  };

  news.display = "silent";
  systemd.user.startServices = "sd-switch";

  imports = [
    ./gnupg.nix
    ./git.nix
    ./vim.nix
    ./zsh.nix
    ./neovim.nix
  ];
}
