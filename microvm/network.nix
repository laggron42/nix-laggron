{ lib, ... }: {

  # This file contains the host-side network configuration
  #
  # It configures the proper network devices to provide VMs
  # with internet access, as well as access to the host's network

  networking.useNetworkd = true;
  systemd.network.enable = true;

  # enable NAT to provide internet access
  networking.nat = {
    enable = true;
    enableIPv6 = true;
    
    # this range will match all VMs
    internalIPs = [ "10.0.0.0/24" ];

    # network device on the host machine with internet acces
    externalInterface = "enp41s0";
  };

  systemd.network = {
    # each VM will get its own network device configured
    networks = builtins.listToAttrs (
      lib.imap0 (i: name: {
        name = "30-vm${toString i}-${name}";
        value = {

          matchConfig.Name = "vm${toString i}-${name}";

          # host addresses
          address = [
            "10.0.0.0/32"
            "fec0::/128"
          ];

          # setup routes to the VM
          routes = [ {
            # the counter is incremented by 10 to avoid using 10.0.0.0 (gateway)
            Destination = "10.0.0.${toString (i + 10)}/32";
          } {
            Destination = "fec0::${lib.toHexString i}/128";
          } ];

          # enable routing
          networkConfig = {
            IPv4Forwarding = true;
            IPv6Forwarding = true;
          };
        };
      }) (import ./vm-list.nix));
  };

}
