{ config, pkgs, misc, ... }: {

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };


  # packages are just installed (no configuration applied)
  # programs are installed and configuration applied to dotfiles
  home.packages = [
    # user selected packages
    pkgs.age
    pkgs.ansible
    pkgs.awscli2
    pkgs.azure-cli
    pkgs.bandwhich
    pkgs.bitwarden-cli
    pkgs.chkrootkit
    pkgs.cargo
    pkgs.cargo-wasi
    pkgs.dbus
    pkgs.dconf
    pkgs.dconf2nix
    pkgs.dhall
    pkgs.dhall-bash
    pkgs.dhall-json
    pkgs.dhall-lsp-server
    pkgs.dhall-nix
    pkgs.dhall-yaml
    pkgs.dig
    pkgs.ffmpeg
    pkgs.flac
    pkgs.fontconfig
    pkgs.gcc_multi
    pkgs.get_iplayer
    pkgs.github-cli
    pkgs.gnumake
    pkgs.go
    pkgs.gosec
    pkgs.go-jira
    pkgs.groovy
    pkgs.hub
    pkgs.get_iplayer
    pkgs.git-crypt
    pkgs.jbake
    pkgs.jbang
    pkgs.jdk17
    pkgs.jq
    pkgs.krb5
    pkgs.krew
    pkgs.kubectl
    pkgs.kubectl-tree
    pkgs.kubectl-view-secret
    pkgs.kubebuilder
    pkgs.kubernetes-helm
    pkgs.kustomize
    pkgs.k9s
    pkgs.lame
    pkgs.lm_sensors
    pkgs.maven
    pkgs.mediainfo
    pkgs.mkvtoolnix-cli
    pkgs.mlocate
    pkgs.minikube
    pkgs.ocm
    pkgs.openldap
    pkgs.openshift
    pkgs.openssl
    pkgs.operator-sdk
    pkgs.python311Full
    pkgs.python311Packages.pip
    pkgs.python311Packages.psutil
    pkgs.rtorrent
    pkgs.rustc
    pkgs.rustfmt
    pkgs.rust-analyzer
    pkgs.sops
    pkgs.syncthing
    pkgs.texinfoInteractive
    pkgs.tmux
    pkgs.unixtools.netstat
    pkgs.libossp_uuid
    pkgs.virtualenv
    pkgs.weechat
    pkgs.wireguard-tools
    pkgs.wl-clipboard
    pkgs.yt-dlp
    pkgs.yubikey-manager
    pkgs.yubioath-flutter
    # Fleek Bling
    pkgs.git
    pkgs.htop
    pkgs.github-cli
    pkgs.glab
    pkgs.fzf
    pkgs.ripgrep
    pkgs.vscode
    pkgs.lazygit
    pkgs.jq
    pkgs.yq-go
    pkgs.neovim
    pkgs.neofetch
    pkgs.btop
    pkgs.cheat
    pkgs.just
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

    # OpenStack
    pkgs.openstackclient
    pkgs.swiftclient
  ];
  fonts.fontconfig.enable = true;
  home.stateVersion =
    "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;
}
