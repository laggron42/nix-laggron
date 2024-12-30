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

    ignores = [
      ".DS_Store"
      "*~"
      "*.swp"
    ];
    extraConfig = {
      commit.verbose = true;
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      branch.autoSetupRebase = "always";
      rerere.enabled = true;
    };

    aliases = {
      advlog = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      atag = "tag --annotate -m \"\"";
    };

    lfs.enable = true;
    diff-so-fancy.enable = true;

    includes = [
      {
        condition = "hasconfig:remote.*.url:*epita.fr:**/**";
        contents = {
          user.email = "auguste.charpentier@epita.fr";
        };
      }
      {
        condition = "hasconfig:remote.*.url:*gitlab.com:prologin/**/**";
        contents = {
          user.email = "auguste.charpentier@prologin.org";
        };
      }
    ];
  };
}
