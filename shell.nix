{ pkgs, misc, ... }: {

  programs.atuin.enable = true;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.starship.enable = true;
  programs.dircolors.enable = true;

  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  # bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    #enableVteIntegration = true;

    profileExtra = ''
      [ -r ~/.nix-profile/etc/profile.d/nix.sh ] && source  ~/.nix-profile/etc/profile.d/nix.sh
      export XCURSOR_PATH=$XCURSOR_PATH:/usr/share/icons:~/.local/share/icons:~/.icons:~/.nix-profile/share/icons
    '';

    initExtra = ''
      if [ -f /etc/bashrc ]; then
          . /etc/bashrc
      fi
    '';
  };
}
