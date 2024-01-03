{ config, lib, inputs, pkgs, misc, ... }: {




  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    client = {
      enable = true;
      arguments =  [
        "-c"
      ];
    };
    defaultEditor = true;
    startWithUserSession = true;
  };
}
