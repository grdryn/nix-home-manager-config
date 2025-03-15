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
{ pkgs, lib, misc, ... }: {

  programs.direnv.enable = true;
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

    cat = "bat";

    # bat --plain for unformatted cat
    catp = "bat -P";
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      # format = lib.concatStrings [
      #   "$directory"
      #   "$line_break"
      #   "$package"
      #   "$line_break"
      #   "$character"
      # ];
      scan_timeout = 10;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 8;
        truncation_symbol = "…/";
      };
      kubernetes = {
        disabled = false;
        format = "[$cluster :: $namespace]($style) in ";
      };
    };
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
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

      bind -x '"\C-p": __atuin_history'

      #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    '';
  };

  programs.fish = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    # Drop-in includes may be unmanaged or encrypted
    includes = [".config.d/*"];
    controlMaster = "auto";
    controlPersist = "yes";

    extraConfig = ''
      Port 22
    '';

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
        region = "us-east-1";
        output = "json";
      };
    };
    credentials = {
      "default" = {
        credential_process = "aws-bitwarden.sh ca395317-186a-4c26-8453-b05f0105015a";
      };
    };
  };

  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      default_shell = "fish";
    };
  };

}
