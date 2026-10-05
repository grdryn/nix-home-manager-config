/*
  Copyright 2026 Gerard Ryan

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = false;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "code-cursor"
      "cursor"
      "claude-code"
      "mfcl8690cdwlpr"
      "mfcl8690cdwcupswrapper"
    ];

  # Fedora is outside default Ubuntu/Debian/NixOS list
  system-manager.allowAnyDistro = true;

  # Nix configuration for system-manager
  nix.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Users are managed by Fedora itself, not by system-manager. This entry is
  # inert metadata: home-manager's NixOS module reads
  # users.users.<name>.home to derive home.homeDirectory, but with userborn
  # disabled nothing ever acts on it.
  services.userborn.enable = false;
  users.users.grdryn = {
    isNormalUser = true;
    home = "/var/home/grdryn";
    group = "grdryn";
  };
  users.groups.grdryn = { };

  # Upstream system-manager writes shell-style ${USER}/${PATH} into this file;
  # environment.d does not expand them, which poisons PATH in all sessions.
  # The /etc/profile.d/system-manager-path.sh shell variant works fine.
  environment.etc."environment.d/10-system-manager.conf".enable = false;

  # Minimal skeleton system packages
  environment.systemPackages = with pkgs; [ ];
}
