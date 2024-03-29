{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
  ];

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = "polybar --reload &";
    settings = {
      colors = {
        background = "#282A2E";
        background-alt = "#373B41";
        foreground = "#C5C8C6";
        primary = "#F0C674";
        secondary = "#8ABEB7";
        alert = "#A54242";
        disabled = "#707880";
      };

      "bar/example" = {
        width = "100%";
        height = "24pt";
        radius = "6";

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = "3pt";

        border-size = "4pt";
        border-color = "#00000000";

        padding-left = "0";
        padding-right = "1";

        module-margin = "1";

        separator = "|";
        separator-foreground = "\${colors.disabled}";

        font-0 = "monospace;2";

        modules-left = "xworkspaces mpris";
        modules-right = "pulseaudio temperature cpu memory eth date";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = "true";
      };

      "module/systray" = {
        type = "internal/tray";

        format-margin = "8pt";
        tray-spacing = "16pt";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline= "\${colors.primary}";
        label-active-padding = "1";

        label-occupied = "%name%";
        label-occupied-padding = "1";

        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = "1";

        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = "1";
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };

      "module/filesystem" = {
        type = "internal/fs";
        interval = "25";

        mount-0 = "/";

        label-mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";

        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.disabled}";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        format-volume-prefix = "\"VOL \"";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";

        label-volume = "%percentage%%";

        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };

      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";

        label-layout = "%layout%";
        label-layout-foreground = "\${colors.primary}";

        label-indicator-padding = "2";
        label-indicator-margin = "1";
        label-indicator-foreground = "\${colors.background}";
        label-indicator-background = "\${colors.secondary}";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = "\"RAM \"";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage_used:2%%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "2";
        format-prefix = "\"CPU \"";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage:2%%";
      };

      network-base = {
        type = "internal/network";
        interval = "5";
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        label-disconnected = "%{F#F0C674}%ifname%%{F#707880} disconnected";
      };

      "module/wlan" = {
        "inherit" = "network-base";
        interface-type = "wireless";
        label-connected = "%{F#F0C674}%ifname%%{F-} %essid% %local_ip%";
      };

      "module/eth" = {
        "inherit" = "network-base";
        interface-type = "wired";
        label-connected = "%{F#F0C674}%ifname%%{F-} %netspeed% %{F#858886}(%linkspeed%)%{F-}";
      };

      "module/date" = {
        type = "internal/date";
        interval = "1";

        date = "%Y-%m-%d %H:%M:%S";

        label = "%date%";
        label-foreground = "\${colors.primary}";
      };

      "module/temperature" = {
        type = "internal/temperature";
        warn-temperature = "85";
        label = "%{F#F0C674}TEMP%{F-} %temperature-c%";
        label-warn = "%{F#F0C674}TEMP%{F-} %{F#F07474}%temperature-c%%{F-}";
      };

      "module/mpris" = {
        type = "custom/script";
        exec = "${pkgs.playerctl}/bin/playerctl metadata -F --format \"{{ emoji(status) }} {{ title }} - {{ artist }}\"";
        label = "%output:0:75:...%";
        tail = "true";
      };

      settings = {
        screenchange-reload = "true";
        pseudo-transparency = "true";
      };
    };
  };

  # binds to tray.target by default, but this target is never active
  # setting it to graphical-session ensures it is started by home-manager
  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
