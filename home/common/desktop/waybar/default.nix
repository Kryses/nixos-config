{ inputs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin = "9 13 -10 18";

        modules-left =
          [ "hyprland/workspaces" "hyprland/submap" "custom/daily-verse" "custom/weather" ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/github_notifications"
          "pulseaudio"
          "custom/mem"
          "cpu"
          "backlight"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = { disable-scroll = true; };

        "hyprland/language" = {
          format-en = "US";
          min-length = 5;
          tooltip = false;
        };

        "custom/github_notifications" = {
          format = "{}";
          tooltip = true;
          interval = 300;
          exec = ./custom/github_notifications.sh;
          on-click = "xdg-open https://github.com/notifications";
        };
        "custom/daily-verse" = {
          exec = ./custom/daily-verse.sh;
          interval = 120;

          return-type = "json";

          # OLD-SCHOOL JSON mode:
          # "{}" means "use the 'text' field from JSON"
          format = "{}";

          # Waybar will automatically use the JSON 'tooltip' field
          # when tooltip = true.
          tooltip = true;

          # Allow Pango markup in tooltip
          markup = true;

          max-length = 25;
        };
        "clock" = {
          # timezone = "America/New_York";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format = "{:%a; %d %b, %I:%M %p}";
        };

        "custom/weather" = {
          exec = ./custom/weather.sh;
          return-type = "json";
          format = "{}";
          tooltip = true;
          interval = 900;
        };

        "pulseaudio" = {
          # scroll-step = 1; # %, can be a float
          reverse-scrolling = 1;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
          min-length = 13;
        };

        "custom/mem" = {
          format = "{} ";
          interval = 3;
          exec = "free -h | awk '/Mem:/{printf $3}'";
          tooltip = false;
        };

        "cpu" = {
          interval = 2;
          format = "{usage}% ";
          min-length = 6;
        };

        "temperature" = {
          # thermal-zone = 2;
          # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          # format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" "" "" ];
          tooltip = false;
        };

        "backlight" = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = [ "" ];
          min-length = 7;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" "" ];
          on-update = "$HOME/.config/waybar/scripts/check_battery.sh";
        };

        tray = {
          icon-size = 16;
          spacing = 0;
          expand = true;
          show-passive-items = true;
        };
      };
    };
    style = builtins.readFile ./waybar-style.css;
  };
}
