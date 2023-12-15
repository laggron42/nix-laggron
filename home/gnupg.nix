{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
  ];

  # SSH_AUTH_SOCK might be already set and should be overwritten
  # gpg-agent.nix does not override SSH_AUTH_SOCK, so we unset it
  home.sessionVariablesExtra = ''
    unset SSH_AUTH_SOCK
  '';

  programs = {
    ssh = {
      enable = true;
      forwardAgent = true;
    };

    gpg = {
      enable = true;
      publicKeys = [
        {
          text = builtins.readFile(builtins.fetchurl {
            url = "https://keys.openpgp.org/vks/v1/by-fingerprint/550B75F1FFB8CB5D047F52DA03BE32E52B95C97F";
            sha256 = "06345r8nc3l2pxbzhr1jq6l17zzxh8h85296ymp3zmyfvhzqfkgw";
          });
          trust = 5;
        }
      ];
    };
  };

  services = (if !pkgs.stdenv.isDarwin then {
      gpg-agent = {
        enable = true;
        verbose = true;
        enableSshSupport = true;
      };
    }
  else {});
}