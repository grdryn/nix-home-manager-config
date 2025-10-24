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
{ config, inputs, pkgs, misc, ... }: {

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Gerard Ryan";
        email = "git@grdryn.xyz";
      };

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

      feature.manyFiles = false; # needs to be false for libgit2
      gpg.format = "ssh";

      core = {
        pager = "delta";
        whitespace = "trailing-space,space-before-tab";
        quotepath = false;
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      delta = {
        line-numbers = true;
        navigate = true;    # use n and N to move between diff sections
        side-by-side = true;
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
        colorMoved = "default";
        tool = "emerge";
      };

      difftool = {
        prompt = false;
      };

      merge = {
        conflictstyle = "diff3";
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

    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = builtins.stringLength "~/.ssh/id_ed25519" > 0;
    };

    lfs.enable = true;

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
      ".direnv"
      "result"
    ];
  };
}
