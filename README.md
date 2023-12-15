# nix-laggron

This repository holds my personal [Nix](https://nixos.org) configuration files.

The end goal is to have a portable config that will work on

- Full NixOS systems (unused yet, will be porting servers)
- Apple M1 computers through [nix-darwin](https://github.com/LnL7/nix-darwin)
- EPITA's PIE environment (distributed NixOS without root permissions)
- Any system (Linux/macOS/WSL) with [the nix package manager](https://nixos.org) installed

[Home manager](https://github.com/nix-community/home-manager) is used and works on all the above
for sharing user-specific settings.

## How to use

### Home manager

1. Install [home-manager](https://github.com/nix-community/home-manager) without using module-based
   install
2. Download this repository
3. Run `home-manager -f path/to/nix-laggron`
