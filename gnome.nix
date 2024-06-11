/*
 *  Copyright 2024 Gerard Ryan
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
{ lib, inputs, pkgs, misc, ... }: {

  imports = [
    inputs.xhmm.homeManagerModules.desktop.gnome
  ];

  gnome.extensions = {
    enable = true;
    enabledExtensions = with pkgs.gnomeExtensions; [
      #alt-tab-workspace doesn't exist
      appindicator
      clipboard-history
      containers
      coverflow-alt-tab
      #easyScreenCast broken
      #emoji-selector
      freon
      gtile
      impatience
      openweather
      removable-drive-menu
    ];
    extraExtensions = [];
  };

  programs.gnome-terminal = {
    enable = true;
    profile = {
      b1dcc9dd-5262-4d8d-a863-c897e6d979b9 = {
        customCommand = "/bin/bash";
        default = false;
        visibleName = "Bash";
        transparencyPercent = 0;
      };
      d222592d-cd9a-4eec-9f30-872afac9f473 = {
        customCommand = "/usr/bin/env fish";
        default = true;
        visibleName = "Fish";
        transparencyPercent = 25;
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      monospace-font-name = "FiraCode Nerd Font Mono Bold 11";
      clock-show-date = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = lib.hm.gvariant.mkUint32 7;
      remove-old-trash-files = true;
      report-technical-problems = true;
    };

    "org/gnome/desktop/search-providers" = {
      disable-external = true;
    };

    "org/gnome/software" = {
      allow-updates = false;
      download-updates = false;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezon = true;
    };

    "org/gnome/clocks" = {
      world-clocks = "[{'location': <(uint32 2, <('Raleigh', 'KRDU', true, [(0.62605930672100707, -1.3750818938070426)], [(0.62434085553949348, -1.3725027509582006)])>)>}, {'location': <(uint32 2, <('Atlanta', 'KATL', true, [(0.58713361238621309, -1.4735281501968716)], [(0.5890310819891037, -1.4728481350137095)])>)>}, {'location': <(uint32 2, <('Rio de Janeiro', 'SBRJ', true, [(-0.39968039870670141, -0.75340046626198298)], [(-0.39968039870670141, -0.75456400746111763)])>)>}, {'location': <(uint32 2, <('Waterford', 'EIWF', true, [(0.91083885136922016, -0.12369050670445701)], [(0.91207997245360595, -0.1241268390174556)])>)>}, {'location': <(uint32 2, <('Brno', 'LKTB', true, [(0.857829327355213, 0.291469985083053)], [(0.85870199198121022, 0.29030642643062599)])>)>}, {'location': <(uint32 2, <('Istanbul', 'LTBA', true, [(0.71500322271810779, 0.50294571860079684)], [(0.71590981654476371, 0.505529765824837)])>)>}]";
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      experimental-features = ["scale-monitor-framebuffer"];
    };

    "org/gnome/shell/overrides" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-last-coordinates = lib.hm.gvariant.mkTuple [ 53.330404550767604 (-6.2591) ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/shell" = {
      disable-extension-version-validation = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ ( lib.hm.gvariant.mkTuple [ "xkb" "us+euro" ]) ];
      xkb-options = [ "caps:ctrl_modifier" ];
    };

    "org/gnome/evolution/calendar" = {
      editor-show-timezone = true;
    };

    "org/gnome/evolution/mail" = {
      composer-reply-start-bottom = true;
      composer-unicode-smileys = true;
      mark-seen-timeout = 0;
      preview-unset-html-colors = true;
      prompt-on-mark-all-read = false;
      show-sender-photo = true;
      search-gravatar-for-photo = true;
    };

    "org/gnome/evolution/plugin/prefer-plain" = {
      mode = "normal";
      show-suppressed = true;
    };
  };

}
