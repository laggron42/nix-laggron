{ config, pkgs, ... }:

{
  # p10k fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    meslo-lgs-nf
  ];

  programs.zsh = {

    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}