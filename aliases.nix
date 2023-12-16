{ pkgs, misc, ... }: {

  home.shellAliases = {
    "apply-localhost.localdomain" = "nix run --impure home-manager/master -- -b bak switch --flake .#gryan@localhost.localdomain";

    "fleeks" = "cd ~/.local/share/fleek";

    "j!" = "jbang";

    "latest-fleek-version" = "nix run https://getfleek.dev/latest.tar.gz -- version";

    "update-fleek" = "nix run https://getfleek.dev/latest.tar.gz -- update";

    cd = "z";

    cat = "bat";

    # bat --plain for unformatted cat
    catp = "bat -P";
  };

}
