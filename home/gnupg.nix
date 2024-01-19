{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
  ];

  programs = {
    ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "ssh.cri.epita.fr" = {
          extraOptions = {
            GSSAPIAuthentication = "yes";
            GSSAPIDelegateCredentials = "yes";
          };
        };
      };
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
