{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    signing = {
      signByDefault = true;
      key = "0x03BE32E52B95C97F";
    };
    userName = "Auguste Charpentier";
    userEmail = "laggron42@gmail.com";

    aliases = {
      advlog = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
    };

    lfs.enable = true;
    diff-so-fancy.enable = true;
  };
}
