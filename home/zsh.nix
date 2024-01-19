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
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  } // (
    if (config.home.stateVersion == "23.05") then {
      enableSyntaxHighlighting = true;
    } else {
      syntaxHighlighting.enable = true;
    }
  );
}
