{ config, lib, inputs, pkgs, misc, ... }: {

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.xhmm.homeManagerModules.desktop.gnome
  ];

  gnome.extensions = {
    enable = true;
    enabledExtensions = with pkgs.gnomeExtensions; [
      #alt-tab-workspace doesn't exist
      appindicator
      clipboard-history
      containers
      coverflow-alt-tab
      #easyScreenCast broken
      emoji-selector
      freon
      gtile
      impatience
      openweather
      removable-drive-menu
    ];
    extraExtensions = [];
  };

  sops = {
    age.keyFile = "/var/home/gryan/.config/sops/age/keys.txt";
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets = {
      github_gitconfig = {
        sopsFile = ./secrets/github.gitconfig;
        format = "binary";
        path = "${config.home.homeDirectory}/.config/git/config.d/github.gitconfig";
      };
    };
  };

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

      bind -x '"\C-p": __atuin_history'

      #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    '';
  };

  # https://atuin.sh/docs/config/
  programs.atuin.settings = {
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

  programs.git = {
    includes = [
      { path = config.sops.secrets.github_gitconfig.path; }
    ];

    ignores = [
      "*~"
      "*.swp"
      ".stfolder"
      ".tern-port"
      ".tern-project"
      ".tramp_history"
      "TAGS"
      ".classpath"
      ".factorypath"
      ".project"
      ".settings"
      "__pycache__"
    ];

    aliases = {
      br = "branch";
      s = "status -u -s";
      cl = "log --stat -C -2";
      c = "commit";
      ci = "commit -a";
      co = "checkout";
      d = "diff --color-words";
      dh = "diff HEAD";
      dc = "diff --staged";
      dw = "diff --word-diff";
      dcw = "diff --color-words";
      who = "shortlog -s --";
      ph = "push";
      pl = "pull";
      lp = "log -p";
      lod = "log --oneline --decorate";
      lg = "log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
      lpo = "log --pretty=oneline --abbrev-commit --graph --decorate --all";
      spull = "!git-svn fetch && git-svn rebase";
      spush = "!git-svn dcommit";
      sync = "!git pull && git push";
      es = "!git pull --rebase && git push";
      lf = "log --pretty=fuller";
      ignorechanges = "update-index --assume-unchanged";
      noticechanges = "update-index --no-assume-unchanged";
      gc-ap = "gc --aggressive --prune";
      listconf = "config --global --list";
      cam = "commit -a -m";
      lsm = "log -M --stat";
      hse = "log --stat -5";
      diffall = "diff HEAD";
      logr = "log -M";
      logr2 = "log --stat -M -2";
      logit = "log --stat -M";
      scrub = "!git reset --hard && git clean -fd";
      pubdev = "!git pub checkout master && git pull && git checkout dev && git rebase master && git checkout master && git merge dev && git wtf";
      pub = "push -u origin";
      cs = "status";
      rv = "remote -v";
      lwr = "log --stat -C";
      pur = "pull --rebase";
      whatis = "show -s --pretty='tformat:%h (%s, %ad)' --date=short";
      k = "!exec gitk --all&";
      testecho1 = "!sh -c 'echo with slash: zero=$0 one=$1 two=$2' -";
      # te1 RESULT: with slash: zero=- one=A two=B;
      testecho2 = "!sh -c 'echo without slash: zero=$0 one=$1 two=$2'";
      # te2 RESULT: without slash: zero=A one=B two=C;
      st = "status";
      l = "log --stat -C";
      ll = "log --stat -C -3";
      servehere = "daemon --verbose --informative-errors --reuseaddr --export-all --base-path=. --enable=receive-pack";
      purgeme = "!git clean -fd && git reset --hard";
      prunenow = "gc --prune=now";
      ri = "rebase --interactive --autosquash";
      lol = "log --pretty=oneline --graph --abbrev-commit --all";
      blg = "log --graph --decorate --all --abbrev-commit --pretty=oneline";
      slog = "log --graph --simplify-by-decoration --all --abbrev-commit --pretty=oneline";
      lgso = "log --graph --date=short --pretty=format:'%C(yellow)%h%Creset %cn%x09%cd %s%C(green bold)%d'";
      ro = "!git fetch origin && git reset --hard origin/master";
      shorten = "!sh -c 'curl -i https://git.io -F url=$1' -";
      pushnotes = "!sh -c 'git push $1 refs/notes/*' -";
      fetchnotes = "!sh -c 'git fetch $1 refs/notes/*:refs/notes/*' -";
      showignored = "clean -ndX";
      showignored2 = "ls-files --others --ignored --exclude-standard";
      showuntracked = "ls-files --others --exclude-standard";
      rmmissing = "!git rm $(git ls-files --deleted)";
      mergekeepoursonly = "merge -s ours";
      redocommit = "reset --soft HEAD^";
      listunstaged = "diff --name-status";
      liststaged = "diff --name-status --staged";
      listhistory = "log --name-status";
      logn = "log --oneline --name-only";
      busypeople = "shortlog -6";
      busythisweek = "shortlog --since=one.week.ago";
      configpushtracking = "config push.default tracking";
      configpushnothing = "config push.default nothing";
      configpushmatching = "config push.default matching";
      configpushcurrent = "config push.default current";

      # Other alias ideas that don't quite work yet;
      #testnewrepodoesntwork1 = "!echo git init $1 && echo cd $1";
      #testnewrepodoesntwork2 = "!sh -c 'git init $1; echo hi' -";
      #testnewrepodoesntwork3 = "!f() { git init $1}; f";
      nr = "!sh -c 'git init $0'";
      echoparam1 = "!sh -c 'echo $0'";
      #testshfunction = "!function gitme() { git init $1; cd $1; }; gitme";

      fixup = "!sh -c 'git commit -m \"fixup! $(git log -1 --format='\\''%s'\\'' $@)\"' -";
      squash = "!sh -c 'git commit -m \"squash! $(git log -1 --format='\\''%s'\\'' $@)\"' -";
      ccfq = "!sh -c 'git add $1 && git commit -m\"Placeholder\"' -";
      logme = "log --author='Gerard Ryan' --stat -C";
      cob = "checkout -b";
      sno = "show --name-only";
      logsimple = "log --graph --abbrev-commit --pretty=oneline --all --decorate";
      gwcl = "log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      rlog = "log --color-words --stat -3";
      lm = "log --stat -M";

      #Searches;
      findmydeletes = "log --author='Gerard Ryan' --diff-filter=D --since=2.years.ago";

      #https://git.wiki.kernel.org/index.php?title=Aliases;
      oneline ="!_() { $(test $# -eq 0 && echo xargs -L1) git log --no-walk --decorate --oneline \"$@\"; }; _";
      tips = "!_() { t=$(git rev-list --no-merges --max-count=1 \"$@\"); if test -n \"$t\"; then echo $t; _ \"$@\" ^$t; fi; }; _";
      empty-tree-sha1 = "hash-object -t tree /dev/null";
      whitespaceviolations = "!git diff --check $(git empty-tree-sha1)";
      patchforthis = "!git diff -p $(git empty-tree-sha1)";
      tagcontains = "git tag -l --contains HEAD";
      cc-cache = "config --global credential.helper 'cache --timeout=300'";
      cc-off = "config --unset --global credential.helper";
      cc-helperosx = "config --global credential.helper 'osxkeychain'";
      cc-helperwin = "config --global credential.helper 'wincred'";
      cc-helperlin = "config --global credential.helper '/pathto/git-credential-gnome-key'";
      logm = "log --stat -M";
      logcpy = "log --stat -1 -C -C";
      pushsvn = "svn dcommit";
      pullsvn = "svn rebase";
      nfjsunpushed = "log origin/master..master --oneline";
      rtheirs = "!git checkout --theirs ./ && git add . && git rebase --continue";
      logfive = "log --graph --pretty=oneline --abbrev-commit --decorate --all -5";
      noderelnotes = "git log --graph --pretty=format:'%h%d %s (%an)'";
      configsimplelog = "config format.pretty oneline";
      app = "commit -a --amend --no-edit";
      cia = "commit -a --amend";
      up = "fetch --all --prune --tags";
    };

    extraConfig = {
      core = {
        whitespace = "trailing-space,space-before-tab";
        quotepath = false;
      };

      color = {
        ui = "auto";
      };

      credential = {
        helper = "store";
      };

      rerere = {
        enabled = true;
      };

      apply = {
        whitespace = "nowarn";
      };

      diff = {
        tool = "emerge";
      };

      difftool = {
        prompt = false;
      };

      merge = {
        tool = "emerge";
      };

      mergetool = {
        prompt = false;
        keepBackup = false;
      };

      url = {
        "ssh://git@github.com/" = {
          insteadOf = "ghs://";
          pushInsteadOf = "ghs://";
        };

        "ssh://git@github.com/grdryn/" = {
          insteadOf = "ghsm://";
          pushInsteadOf = "ghsm://";
        };

        "https://github.com/" = {
          insteadOf = "ghh://";
          pushInsteadOf = "ghh://";
        };

        "https://github.com/grdryn/" = {
          insteadOf = "ghhm://";
          pushInsteadOf = "ghhm://";
        };
      };

      hub = {
        protocol = "ssh";
      };

      gist = {
        private = "yes";
        browse = "yes";
      };

      push = {
        default = "current";
      };

      commit = {
        template = "~/.git-commit-template";
      };

      init = {
        templatedir = "~/.git_template";
        defaultBranch = "main";
      };

      magit = {
        hideCampaign = true;
      };

      gitlab = {
        user = "gryan";
      };

      # 'gitlab "gitlab.cee.redhat.com/api/v4"' = {
      #   user = "gryan";
      # };

      rh-pre-commit = {
        checkSecrets = true;
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      monospace-font-name = "FiraCode Nerd Font Mono Bold 11";
      clock-show-date = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = lib.hm.gvariant.mkUint32 7;
      remove-old-trash-files = true;
      report-technical-problems = true;
    };

    "org/gnome/desktop/search-providers" = {
      disable-external = true;
    };

    "org/gnome/software" = {
      allow-updates = false;
      download-updates = false;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezon = true;
    };

    "org/gnome/clocks" = {
      world-clocks = "[{'location': <(uint32 2, <('Raleigh', 'KRDU', true, [(0.62605930672100707, -1.3750818938070426)], [(0.62434085553949348, -1.3725027509582006)])>)>}, {'location': <(uint32 2, <('Atlanta', 'KATL', true, [(0.58713361238621309, -1.4735281501968716)], [(0.5890310819891037, -1.4728481350137095)])>)>}, {'location': <(uint32 2, <('Rio de Janeiro', 'SBRJ', true, [(-0.39968039870670141, -0.75340046626198298)], [(-0.39968039870670141, -0.75456400746111763)])>)>}, {'location': <(uint32 2, <('Waterford', 'EIWF', true, [(0.91083885136922016, -0.12369050670445701)], [(0.91207997245360595, -0.1241268390174556)])>)>}, {'location': <(uint32 2, <('Brno', 'LKTB', true, [(0.857829327355213, 0.291469985083053)], [(0.85870199198121022, 0.29030642643062599)])>)>}, {'location': <(uint32 2, <('Istanbul', 'LTBA', true, [(0.71500322271810779, 0.50294571860079684)], [(0.71590981654476371, 0.505529765824837)])>)>}]";
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/shell/overrides" = {
      workspaces-only-on-primary = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-last-coordinates = lib.hm.gvariant.mkTuple [ 53.330404550767604 (-6.2591) ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/shell" = {
      disable-extension-version-validation = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ ( lib.hm.gvariant.mkTuple [ "xkb" "us+euro" ]) ];
      xkb-options = [ "caps:ctrl_modifier" ];
    };
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
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
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
