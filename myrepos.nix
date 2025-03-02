{ pkgs, misc, ... }:
{
  home.packages = [ pkgs.mr ];

  programs.mr = {
    enable = true;
    settings = {
      ".config/home-manager" = {
        checkout = "git clone 'git@github.com:grdryn/nix-home-manager-config.git' 'home-manager'";
      };

      ".emacs.d" = {
        # bbatsov is the upstream prelude project
        checkout = "
        git clone 'git@github.com:grdryn/prelude.git' '.emacs.d'
        pushd .emacs.d
          git remote add bbatsov 'git@github.com:bbatsov/prelude.git'
        popd";
      };
    };
  };
}
