{ lib, pkgs, ... }: {

  imports = [
    ./network.nix
  ];

  microvm.vms = builtins.listToAttrs (lib.imap0 (i: name: let
    hash = builtins.hashString "sha256" name;
    c = off: builtins.substring off 2 hash;
    mac = "${builtins.substring 0 1 hash}2:${c 2}:${c 4}:${c 6}:${c 8}:${c 10}";
  in {
    name = name;
    value = {
      config = import ./base-vm.nix {
        lib = lib;
        pkgs = pkgs;
        name = name;
        mac = mac;
        i = i;
      };
    };
  }) (import ./vm-list.nix));

}
