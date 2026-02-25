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
{ config, inputs, pkgs, misc, ... }:

{

  targets.genericLinux = {
    enable = true;
    gpu.enable = false;
  };

  xdg.userDirs.enable = true;

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets = {
      github_gitconfig = {
        sopsFile = ./secrets/github.gitconfig;
        format = "binary";
        path = "${config.home.homeDirectory}/.config/git/config.d/github.gitconfig";
      };
      lastfm_password = {
        format = "yaml";
        sopsFile = ./secrets/mpdscribble.yaml;
      };
      librefm_password = {
        format = "yaml";
        sopsFile = ./secrets/mpdscribble.yaml;
      };
    };
  };

  programs.git = {
    includes = [
      { path = config.sops.secrets.github_gitconfig.path; }
    ];
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = false;
    };
  };

  home.packages = with pkgs; [

    git-sim
    lm_sensors
    mlocate
    openldap # TODO: clashes with zulu jdk17 on macos
    poetry
    strace
    wl-clipboard
    yubioath-flutter
  ];

  programs.fish = {
    prompt = "echo \>";
  };

}
