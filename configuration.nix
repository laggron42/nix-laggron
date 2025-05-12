{ config, lib, pkgs, ... }: {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  # Enable Ethernet networking
  networking.hostName = "koraidon";
  networking.networkmanager.enable = true;

  # Enable flakes on the system
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  # User settings goes here
  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [./authorized_keys];
  };

  # Manage OpenSSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    file
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # MOTD displayed on SSH logon
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        command = "${pkgs.nettools}/bin/hostname | ${pkgs.figlet}/bin/figlet | ${pkgs.lolcat}/bin/lolcat -f";
        color = "white";
      };
      service_status = {
        Firewall = "firewall";
        SSH = "sshd";
      };
      uptime.prefix = "Uptime:";
      # Uncomment for NixOS 25.05
      #load_avg.format = "Load (1, 5, 15 min.): {one:.02}, {five:.02}, {fifteen:.02}";
      filesystems = {
        root = "/";
        boot = "/boot";
      };
      memory.swap_pos = "below";
    };
  };


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

