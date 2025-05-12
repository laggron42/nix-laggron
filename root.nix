{ config, pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  programs.ssh.matchBlocks."10.0.*.*" = {
    StrictHostkeyChecking = "no";
    UserKnownHostsFile = "/dev/null";
  };
}
