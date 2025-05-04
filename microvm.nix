{ config, lib, pkgs, ... }: {

  networking.useNetworkd = true;
  systemd.network = {
    enable = true;

    networks."10-lan" = {
      matchConfig.Name = ["eno1" "vm-*"];
      networkConfig = {
        Bridge = "br0";
      };
    };

    netdevs."br0" = {
      netdevConfig = {
        Name = "br0";
        Kind = "bridge";
      };
    };

    networks."10-lan-bridge" = {
      matchConfig.Name = "br0";
      networkConfig = {
        Address = ["192.168.1.2/24" "2001:db8::a/64"];
        Gateway = "192.168.1.1";
        DNS = ["192.168.1.1"];
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  microvm.vms = {
    my-microvm = {
      config = {
        microvm.shares = [{
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }];
        microvm.interfaces = [{
          type = "tap";
          id = "vm-my-microvm";
          mac = "02:00:00:00:00:02";
        }];
        systemd.network.enable = true;
        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          networkConfig = {
            Address = ["192.168.1.3/24" "2001:db8::b/64"];
            Gateway = "192.168.1.1";
            DNS = ["192.168.1.1"];
            IPv6AcceptRA = true;
            DHCP = "no";
          };
        };
        users.users.root.password = "hai";
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };
      };
    };
  };
}
