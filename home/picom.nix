{ config, pkgs, ... }:

let
  exclusions = [
    "name*?='polybar'"
    "name*?='rofi'"
    "class_g = 'firefox' && window_type = 'utility'"
  ];
in {
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    fadeExclude = exclusions;
    shadow = true;
    shadowExclude = exclusions;
    backend = "glx";
    settings = {
      "corner-radius" = 10;
      #"opacity-rule" = [
      #  "30:class_g = 'i3lock'"
      #];
    };
  };
}
