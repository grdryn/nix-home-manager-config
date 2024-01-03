{ pkgs, misc, ... }: {

  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.starship.enable = true;
  programs.dircolors.enable = true;

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GO111MODULE = "on";
    DOCKER_HOST = "unix:///run/user/$UID/podman/podman.sock";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    PYENV_ROOT = "$HOME/.pyenv";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$GOPATH/bin"
    "$HOME/.krew/bin"
    "$HOME/.jbang/bin"
    "$PYENV_ROOT/bin"
    "$HOME/.cargo/bin"

  ];

  home.shellAliases = {
    "apply-work.laptop" = "pushd ~/.config/home-manager && nix run home-manager/master -- -b bak switch --flake .#gryan@work.laptop && popd";

    "j!" = "jbang";

    cd = "z";

    cat = "bat";

    # bat --plain for unformatted cat
    catp = "bat -P";
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  # https://atuin.sh/docs/config/
  programs.atuin = {
    enable = true;
    settings = {
      dialect = "uk";
      workspaces = true;
      enter_accept = true;
      # Use Ctrl-0 .. Ctrl-9 instead of Alt-0 .. Alt-9 UI shortcuts
      ctrl_n_shortcuts = true;

      common_subcommands = [
        "cargo"
        "go"
        "git"
        "npm"
        "yarn"
        "pnpm"
        "kubectl"
        "oc"
      ];
    };
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
    historyFileSize = 1000000;

    profileExtra = ''
      [ -r ~/.nix-profile/etc/profile.d/nix.sh ] && source  ~/.nix-profile/etc/profile.d/nix.sh
      export XCURSOR_PATH=$XCURSOR_PATH:/usr/share/icons:~/.local/share/icons:~/.icons:~/.nix-profile/share/icons
    '';

    initExtra = ''
      if [ -f /etc/bashrc ]; then
          . /etc/bashrc
      fi

      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      . "$HOME/applications/maven-mvnd/bin/mvnd-bash-completion.bash"
      . "$HOME/applications/go-jira/jira-completion.bash"

      bind -x '"\C-p": __atuin_history'

      #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    '';
  };

  programs.ssh = {
    enable = true;
    # Drop-in includes may be unmanaged or encrypted
    includes = [".config.d/*"];
    controlMaster = "auto";
    controlPersist = "yes";

    matchBlocks = {
      github.extraOptions.UpdateHostKeys = "yes";
    };
  };
  # Workaround for ssh config permissions
  # https://github.com/nix-community/home-manager/issues/322
  # https://stackoverflow.com/questions/76955208/nixos-home-manager-ssh-config-permissions/77496055#77496055
  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''rm -f ~/.ssh/config && cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
  };

  programs.awscli = {
    enable = true;
    settings = {
      "default" = {
        region = "eu-west-1";
        output = "json";
      };
    };
    credentials = {
      "default" = {
        credential_process = "aws-bitwarden.sh ca395317-186a-4c26-8453-b05f0105015a";
      };
    };
  };

}
