{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek.

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GO111MODULE = "on";
    DOCKER_HOST = "unix:///run/user/$UID/podman/podman.sock";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    PYENV_ROOT = "$HOME/.pyenv";
  };

  programs.bash = {
    historyFileSize = 1000000;

    initExtra = ''
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      . "$HOME/applications/maven-mvnd/bin/mvnd-bash-completion.bash"
      . "$HOME/applications/go-jira/jira-completion.bash"

      #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    '';
  };

}
