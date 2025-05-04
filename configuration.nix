{ config, lib, pkgs, ... }:

let
  rootKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/3MWKug10bpDY6iJkKSXdb6Dd05LAwPNlUtc3XiAfekZ3Jjsgdap++XS1hL9VrbTr/sCc831GhOWj93tUVXTCgEeRtPiY6ZoWeUUNeD7Vxc6L41GiaWQYum6mnJ73MNVkzxAyAWFQ4g7yzTpYRJFk0IrBaVdl5AYcAr4HplU7D1WOC3gCerwQnvjwShjUOGYZ9XaXq3hOTylvI8Hp2kv7aq1gmgKrMC8P5wqXbrm5MzRMLMPU6+r4fqbSgqLICLh9VJbVpX5ipRFn+rJDw4lZHSv3j8Pz10my5RYbAsSGlcgWH22Wv8s9kKfdeX+1bWihmit/MC0UILXjI8HxH2IvYHm6IWLueMYv3JxxVmbnS7zeG04L68T7KVtl3MXbavpEvrjCFKrJvZn5jlOYiVktsQSXplWI4aYwVXrFDXt4v/H16bO5A5m1ajTdS4tGIFA5na65HKErugMPbJmcJ1kwVuP6hbDjPwiCL1g+ceRamn3y0xaUuG/F0+KIkoCFthwAjvV0KcSdfASVikIp10MPOCVqATcIIc31LdnWEcYJ14pX13jUD0Uo6nNbZUArKXRLipgwDbkbVpzPSCPFjV4TdmVB8EZEHVOclgavE6aqgeqQ6c/Ll+zh1eidezrj+GHOzy9YUQFLJVMOobuPcUBevWGQTFVmQA4RSQ/SJgLwQw== cardno:20_872_969"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg9TFF3CFBWLoEnLK8ZEaJXv64aqljo5xkalSoJbZLTRi8VGtia4Wo8Yccpz7UDilk2/0VRmdo/YPNEh4kfrjcyKu+C8Ry8EJUXLEftA98e4vZw+HqFaSJzr0O5InrVKnI7OE8tnhNvU9xdnRwyeUwg3zjgu/Rpn1Z69k/S4uNSMlLnHNnvGvU0IhyUfIQ4uHfSkyqlUpKFW4GQ9M73U5JpjXvZ7N4Vi9HKHEDt8MbxtaWmQuMaKIVKyuRF2+1QS1KyKyPnzjdeEPk787Y5v4SEuD68nysLvb0gmWob7TZDz5Q0PmpfoRyO2gPHSkegWiskbITOEjfZ+mG9W7/IoU5 preda@PredaMart"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFc6nuJ3ZrXvJBflDrxYgru4bKsM9PcNyGz+kGrd5WUc Kowlin"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHtv7d+4rAR8BLuVU0TIo8goCfW6pKKEl3gNgGymppH flare"
  ];
in {
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
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["patreon"];
  };

  programs.zsh.enable = true;

  # User settings goes here
  users.defaultUserShell = pkgs.zsh;
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/3MWKug10bpDY6iJkKSXdb6Dd05LAwPNlUtc3XiAfekZ3Jjsgdap++XS1hL9VrbTr/sCc831GhOWj93tUVXTCgEeRtPiY6ZoWeUUNeD7Vxc6L41GiaWQYum6mnJ73MNVkzxAyAWFQ4g7yzTpYRJFk0IrBaVdl5AYcAr4HplU7D1WOC3gCerwQnvjwShjUOGYZ9XaXq3hOTylvI8Hp2kv7aq1gmgKrMC8P5wqXbrm5MzRMLMPU6+r4fqbSgqLICLh9VJbVpX5ipRFn+rJDw4lZHSv3j8Pz10my5RYbAsSGlcgWH22Wv8s9kKfdeX+1bWihmit/MC0UILXjI8HxH2IvYHm6IWLueMYv3JxxVmbnS7zeG04L68T7KVtl3MXbavpEvrjCFKrJvZn5jlOYiVktsQSXplWI4aYwVXrFDXt4v/H16bO5A5m1ajTdS4tGIFA5na65HKErugMPbJmcJ1kwVuP6hbDjPwiCL1g+ceRamn3y0xaUuG/F0+KIkoCFthwAjvV0KcSdfASVikIp10MPOCVqATcIIc31LdnWEcYJ14pX13jUD0Uo6nNbZUArKXRLipgwDbkbVpzPSCPFjV4TdmVB8EZEHVOclgavE6aqgeqQ6c/Ll+zh1eidezrj+GHOzy9YUQFLJVMOobuPcUBevWGQTFVmQA4RSQ/SJgLwQw== cardno:20_872_969"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg9TFF3CFBWLoEnLK8ZEaJXv64aqljo5xkalSoJbZLTRi8VGtia4Wo8Yccpz7UDilk2/0VRmdo/YPNEh4kfrjcyKu+C8Ry8EJUXLEftA98e4vZw+HqFaSJzr0O5InrVKnI7OE8tnhNvU9xdnRwyeUwg3zjgu/Rpn1Z69k/S4uNSMlLnHNnvGvU0IhyUfIQ4uHfSkyqlUpKFW4GQ9M73U5JpjXvZ7N4Vi9HKHEDt8MbxtaWmQuMaKIVKyuRF2+1QS1KyKyPnzjdeEPk787Y5v4SEuD68nysLvb0gmWob7TZDz5Q0PmpfoRyO2gPHSkegWiskbITOEjfZ+mG9W7/IoU5 preda@PredaMart"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFc6nuJ3ZrXvJBflDrxYgru4bKsM9PcNyGz+kGrd5WUc Kowlin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHtv7d+4rAR8BLuVU0TIo8goCfW6pKKEl3gNgGymppH flare"
    ];
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

    terraform
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
        "nix store" = "/nix/store";
      };
      memory.swap_pos = "below";
    };
  };

  # ============================================
  # Below this line are the settings for patreon bots and VMs

  # Enable libvirt integration
  virtualisation.libvirtd.enable = true;

  users.users.patreon = {
    openssh.authorizedKeys.keys = rootKeys;
    isNormalUser = true;

    # authorize access to hypervisor
    extraGroups = [ "libvirtd" ];
  };

  # Bridge for VM networking
  #networking.bridges.br0.interfaces = [ "enp41s0" ];


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

