/*
  Copyright 2026 Gerard Ryan

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
{
  config,
  inputs,
  pkgs,
  misc,
  ...
}:
{

  system.primaryUser = "gryan";

  # firefox-bin repacks Mozilla's DMG, which invalidates Mozilla's code
  # signature on the launcher (hidden as .firefox-old). macOS AMFI kills
  # unsigned code with restricted entitlements on launch. Re-sign ad-hoc
  # so the browser can start.
  nixpkgs.overlays = [
    (final: prev: {
      firefox-bin = prev.firefox-bin.overrideAttrs (old: {
        # firefox-bin uses buildCommand, which bypasses all stdenv phases,
        # so postInstall hooks never run — append to buildCommand instead.
        buildCommand = (old.buildCommand or "") + ''
          MACOS_DIR="$out/Applications/Firefox.app/Contents/MacOS"
          for f in \
            "$MACOS_DIR/.firefox-old" \
            "$MACOS_DIR/plugin-container" \
            "$MACOS_DIR/crashhelper" \
            "$MACOS_DIR/pingsender" \
            "$MACOS_DIR/nmhproxy" \
            "$MACOS_DIR/gpu-helper.app/Contents/MacOS/Firefox GPU Helper" \
            "$MACOS_DIR/plugin-container.app/Contents/MacOS/plugin-container"; do
            if [ -e "$f" ]; then
              d=$(dirname "$f")
              b=$(basename "$f")
              chmod u+w "$d"
              tmp="$d/.$b.to-sign"
              rm -f "$tmp"
              # f may be a symlink into the read-only unwrapped store
              # path; sign a real copy and swap it in.
              cp "$f" "$tmp"
              chmod u+w "$tmp"
              /usr/bin/codesign --remove-signature "$tmp" 2>/dev/null || true
              /usr/bin/codesign -f -s - "$tmp"
              rm -f "$f"
              mv "$tmp" "$f"
              chmod 555 "$f"
            fi
          done
        '';
        __impureHostDeps = (old.__impureHostDeps or [ ]) ++ [
          "/usr/bin/codesign"
          "/usr/sbin/spctl"
        ];
      });
    })
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    atuin
    code-cursor
    claude-code
    container
    firefox-bin
    fish
    ghostty-bin
    gnused
    nmap
    podman
    podman-compose
    podman-desktop
    starship
    tailscale
    thunderbird-bin
    tree
    utm
    vfkit
  ];

  services.tailscale = {
    enable = true;
  };

  # Keep CrowdStrike Falcon from monopolizing CPU during spikes.
  launchd.daemons.renice-crowdstrike = {
    script = ''
      for pid in $(/usr/bin/pgrep -f com.crowdstrike.falcon); do
        /usr/bin/renice 20 -p "$pid"
      done
    '';

    serviceConfig = {
      Label = "com.renice-crowdstrike";
      StartInterval = 300;
      RunAtLoad = true;
      StandardOutPath = "/tmp/renice-crowdstrike.log";
      StandardErrorPath = "/tmp/renice-crowdstrike.log";
    };
  };

  homebrew = {
    enable = true;

    # Automatically update Homebrew and lift uninstalled casks
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    # Taps you want to add
    # taps = [
    #   "nvidia/openshell"
    # ];

    # CLI tools you want from Brew instead of Nix
    brews = [
      "docker"
      "gnu-sed"
      "mas" # Mac App Store CLI
    ];

    # GUI Apps (Casks) you want to manage
    casks = [
      "docker-desktop"
    ];
  };

  # Auto upgrade nix package and the daemon service.
  #nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.config.allowUnfree = true;

  # Keep sudo Touch ID configuration in nix-darwin-managed sudo_local.
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };

  nix.settings.system = "aarch64-darwin";
  nix.settings.allowed-impure-host-deps = [
    "/usr/bin/codesign"
    "/bin/sh"
    "/dev/random"
    "/dev/urandom"
    "/dev/zero"
    "/usr/lib"
    "/usr/sbin"
  ];
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  users.users.gryan.home = "/Users/gryan";
}
