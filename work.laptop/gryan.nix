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
{ pkgs, misc, ... }: {

    home.username = "gryan";
    home.homeDirectory = "/var/home/gryan";

    targets.genericLinux.enable = true;

    accounts.email.accounts = {
      "work" = {
        address = "ger@redhat.com";
        realName = "Gerard Ryan";
        userName = "gryan@redhat.com";

        aliases = [
          "gryan@redhat.com"
          "grdryn@redhat.com"
        ];
        flavor = "gmail.com";
        primary = true;

        thunderbird = {
          enable = true;
          settings =
            id: {
              "mail.identity.id_${id}.protectSubject" = false;
              "mail.identity.id_${id}.compose_html" = false;
              "mail.server.server_${id}.authMethod" = 10;
              "mail.smtpserver.smtp_${id}.authMethod" = 10;
            };
        };
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles = {
        work = {
          isDefault = true;
        };
      };
    };

    home.packages = with pkgs; [
      thunderbird
    ];

    dconf.settings = {
      # Somehow in UTM/QEMU, this is upside-down
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = true;
      };
    };
}
