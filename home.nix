{ config, pkgs, misc, ... }: {

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages

      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);


    };
  };


  # packages are just installed (no configuration applied)
  # programs are installed and configuration applied to dotfiles
  home.packages = [
    # user selected packages
    pkgs.age
    pkgs.ansible
    pkgs.bitwarden-cli
    pkgs.chkrootkit
    pkgs.cargo
    pkgs.dbus
    pkgs.dconf
    pkgs.dig
    pkgs.flac
    pkgs.fontconfig
    pkgs.gcc_multi
    pkgs.get_iplayer
    pkgs.github-cli
    pkgs.gnumake
    pkgs.go
    pkgs.hub
    pkgs.jbake
    pkgs.jdk17
    pkgs.jq
    pkgs.krb5
    pkgs.krew
    pkgs.kubectl
    pkgs.kubectl-tree
    pkgs.kubectl-view-secret
    pkgs.k9s
    pkgs.lame
    pkgs.lm_sensors
    pkgs.maven
    pkgs.mediainfo
    pkgs.mkvtoolnix-cli
    pkgs.mlocate
    pkgs.ocm
    pkgs.openldap
    pkgs.openshift
    pkgs.openssl
    pkgs.rtorrent
    pkgs.sops
    pkgs.syncthing
    pkgs.texinfoInteractive
    pkgs.tmux
    pkgs.unixtools.netstat
    pkgs.virtualenv
    pkgs.weechat
    pkgs.wireguard-tools
    pkgs.wl-clipboard
    pkgs.yt-dlp
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
  ];
  fonts.fontconfig.enable = true;
  home.stateVersion =
    "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.
  programs.home-manager.enable = true;
}
