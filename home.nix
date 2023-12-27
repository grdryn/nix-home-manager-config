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
    backblaze-b2
    bandwhich
    bitwarden-cli
    chkrootkit
    cargo
    cargo-wasi
    dbus
    dconf
    dconf2nix
    dhall
    dhall-bash
    dhall-json
    dhall-lsp-server
    dhall-nix
    dhall-yaml
    dig
    ffmpeg
    flac
    fontconfig
    gcc_multi
    get_iplayer
    github-cli
    gnumake
    go
    gosec
    go-jira
    groovy
    hub
    get_iplayer
    git-crypt
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
    python311Packages.pip
    python311Packages.psutil
    rtorrent
    rustc
    rustfmt
    rust-analyzer
    sops
    syncthing
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

    # Fleek Bling
    git
    htop
    github-cli
    glab
    fzf
    ripgrep
#    vscode
    lazygit
    jq
    yq-go
    neovim
    neofetch
    btop
    cheat
    just
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    # OpenStack
    openstackclient
    swiftclient
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion =
    "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.

  programs.home-manager.enable = true;
}
