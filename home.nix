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
    # from nixpkgs
    act
    age
    ansible
    awscli2
    #azure-cli
    backblaze-b2
    bandwhich
    #chrysalis
    cargo
    cargo-wasi
    dbus
    dconf
    dconf2nix
    delta
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
    git-extras
    github-cli
    gnumake
    go
    golangci-lint
    gopls
    gosec
    govulncheck
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
    macchina
    maven
    mediainfo
    mergiraf
    mkvtoolnix-cli
    minikube
    ncdu
    nodejs_22
    ocm
    openshift
    openssl
    operator-sdk
    pipenv
    prometheus.cli # promtool, see https://discourse.nixos.org/t/cannot-run-promtool-even-with-prometheus-installed-nixos-minimal/52064/3
    python312Full
    python312Packages.pip
    python312Packages.psutil
    rtorrent
    rustc
    rustfmt
    rust-analyzer
    shellcheck
    sops
    sqlite
    syft
    syncthing
    tektoncd-cli
    texinfoInteractive
    unixtools.netstat
    libossp_uuid
    virtualenv
    weechat
    wireguard-tools
    wl-clipboard
    yt-dlp
    yubikey-manager
    zellij

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

    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    fira-code-symbols # For emacs fira-code mode

    # OpenStack
    openstackclient
    swiftclient

    # hack
    metasploit
    armitage
    sqlmap
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion =
    "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.

  programs.home-manager.enable = true;
}
