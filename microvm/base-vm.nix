{ lib, pkgs, name, mac, i }: {

  system.stateVersion = "24.11";
  networking.hostName = name;

  # VM hardware settings
  microvm = {
    
    # this should be enough for most bots, may be increased
    vcpu = 2;
    mem = 512;

    # share a read-only access to the host's nix-store
    # this considerably reduces build times and disk size
    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }];

    # TAP device for network connectivity
    interfaces = [{
      type = "tap";
      id = "vm${toString i}-${name}";
      inherit mac;
    }];

  };

  # enables networking on the VM
  networking.useNetworkd = true;
  systemd.network.enable = true;

  # configures a network device local to the VM
  systemd.network.networks."10-eth" = {

    matchConfig.MACAddress = mac;

    # static IP configuration
    # follow the same rules as defined in ./network.nix
    address = [
      "10.0.0.${toString (i + 10)}/32"
      "fec0::${lib.toHexString i}/128"
    ];

    routes = [{
      # route to the host
      Destination = "10.0.0.0/32";
      GatewayOnLink = true;
    } {
      # default IPv4 route
      Destination = "0.0.0.0/0";
      Gateway = "10.0.0.0";
      GatewayOnLink = true;
    } {
      # default IPv6 route
      Destination = "::/0";
      Gateway = "fec0::";
      GatewayOnLink = true;
    }];

    # DNS servers no longer come from DHCP nor Router
    # Cloudflare DNS is provided instead
    # https://developers.cloudflare.com/1.1.1.1/ip-addresses/#1111
    networkConfig = {
      DNS = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ];
    };

  };

  # turns on SSH server
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "without-password";
      PasswordAuthentication = false;
    };
  };

  # enable flakes for the "nix profile" command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
  # provide a cooler terminal
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  # provide a few default packages
  environment.systemPackages = with pkgs; [
    vim
    git
    nano
  ];

  # MOTD displayed on SSH logon
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        command = "echo 'Ballsdex hosting' | ${pkgs.figlet}/bin/figlet | ${pkgs.lolcat}/bin/lolcat -f";
        color = "white";
      };
      #service_status = {
        # TODO: Ballsdex bot service
      #};
      uptime.prefix = "Uptime:";
      memory.swap_pos = "below";
    };
  };

  # copy the SSH keys from the local root
  users.users.root.openssh.authorizedKeys.keyFiles = [../authorized_keys];
}
