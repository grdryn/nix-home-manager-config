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
{ config, pkgs, misc, ... }:

let
  aws-bitwarden = pkgs.callPackage ./scripts/aws-bitwarden {};
in
{

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = false;
    };
  };

  services.syncthing.enable = true;

  # packages are just installed (no configuration applied)
  # programs are installed and configuration applied to dotfiles
  home.packages = with pkgs; [
    # custom
    aws-bitwarden

    # from nixpkgs
    age
    ansible
    awscli2
    azure-cli
    #backblaze-b2
    bandwhich
    bitwarden-cli
    chkrootkit
    #chrysalis
    cargo
    cargo-wasi
    dbus
    dconf
    dconf2nix
    delve
    dhall
    dhall-bash
    dhall-json
    dhall-lsp-server
    dhall-nix
    dhall-yaml
    dig
    ffmpeg
    fish
    flac
    fontconfig
    gcc
    gdlv
    get_iplayer
    git-crypt
    github-cli
    gnumake
    go
    gopls
    gosec
    groovy
    hub
    jbake
    jbang
    jdk17
    jq
    krb5
    krew
    kubectl
    kubectl-tree
    kubectl-view-secret
    kubebuilder
    kubernetes-helm
    kustomize
    k9s
    lame
    lm_sensors
    macchina
    maven
    mediainfo
    mkvtoolnix-cli
    mlocate
    minikube
    ncdu
    ocm
    openldap
    openshift
    openssl
    operator-sdk
    python311Full
    python311Packages.libselinux
    python311Packages.pip
    python311Packages.psutil
    rtorrent
    rustc
    rustfmt
    rust-analyzer
    shellcheck
    sops
    sqlite
    syncthing
    tektoncd-cli
    texinfoInteractive
    tmux
    unixtools.netstat
    libossp_uuid
    virtualenv
    weechat
    wireguard-tools
    wl-clipboard
    yt-dlp
    yubikey-manager
    yubioath-flutter

    git
    htop
    github-cli
    glab
    fzf
    ripgrep
    lazygit
    jq
    yq-go
    btop
    cheat
    just

    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; }) # https://nixos.wiki/wiki/Fonts#Installing_specific_fonts_from_nerdfonts
    fira-code-symbols # For emacs fira-code mode

    # OpenStack
    openstackclient
    swiftclient
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion =
    "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.

  programs.home-manager.enable = true;
}
