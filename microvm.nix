{ self, config, lib, pkgs, ... }:
let
  vms = [
    "laggron"
  ];
in {
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;

    networks = builtins.listToAttrs (
      lib.imap0 (i: name: {
        name = "30-vm${toString i}-${name}";
        value = {
          matchConfig.Name = "vm${toString i}-${name}";
          # Host's addresses
          address = [
            "10.0.0.0/32"
            "fec0::/128"
          ];
          # Setup routes to the VM
          routes = [ {
            Destination = "10.0.0.${toString (i + 10)}/32";
          } {
            Destination = "fec0::${lib.toHexString i}/128";
          } ];
          # Enable routing
          networkConfig = {
            IPv4Forwarding = true;
            IPv6Forwarding = true;
          };
        };
      }) vms);
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    internalIPs = [ "10.0.0.0/24" ];
    externalInterface = "enp41s0";
  };

  microvm.vms = builtins.listToAttrs (lib.imap0 (i: name: let
    hash = builtins.hashString "sha256" name;
    c = off: builtins.substring off 2 hash;
    mac = "${builtins.substring 0 1 hash}2:${c 2}:${c 4}:${c 6}:${c 8}:${c 10}";
  in {
    name = name;
    value = {
      config = {
        system.stateVersion = "24.11";
        networking.hostName = name;

        microvm = {
          shares = [{
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
          }];
          interfaces = [{
            type = "tap";
            id = "vm${toString i}-${name}";
            inherit mac;
          }];
        };
        networking.useNetworkd = true;
        systemd.network.enable = true;
        systemd.network.networks."10-eth" = {
          matchConfig.MACAddress = mac;
          # Static IP configuration
          address = [
            "10.0.0.${toString i}/32"
            "fec0::${lib.toHexString i}/128"
          ];
          routes = [ {
            # A route to the host
            Destination = "10.0.0.0/32";
            GatewayOnLink = true;
          } {
            # Default route
            Destination = "0.0.0.0/0";
            Gateway = "10.0.0.0";
            GatewayOnLink = true;
          } {
            # Default route
            Destination = "::/0";
            Gateway = "fec0::";
            GatewayOnLink = true;
          } ];
          networkConfig = {
            # DNS servers no longer come from DHCP nor Router
            DNS = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
          };
        };
        users.users.root.password = "hai";
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };
      };
    };
  }) vms);
}
