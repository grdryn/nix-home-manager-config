{ pkgs, misc, ... }: {

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    defaultEditor = true;
    startWithUserSession = true;
    client = {
      enable = true;
      arguments =  [
        "-c"
      ];
    };
  };
}
