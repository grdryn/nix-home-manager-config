# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix home-manager configuration repository that manages user environment, packages, and dotfiles across multiple machines using a flake-based approach. The configuration is modular and supports different host-specific setups.

## Architecture

### Flake Structure

The repository uses Nix flakes with `flake.nix` as the entry point. The only standalone `homeConfigurations` entry is:

- `grdryn@aorus-desktop` - x86_64 Linux desktop configuration (home-only; see Applying Configuration)

It also defines:
- `darwinConfigurations."gryan-mac"` - system-level macOS configuration via nix-darwin (includes home-manager for gryan).

There is deliberately no `homeConfigurations."gryan@gryan-mac"`: the Mac's home is activated by the home-manager module embedded in `darwinConfigurations."gryan-mac"`, and a standalone entry would be a second owner of the same nix profile (`~/.local/state/nix/profiles/profile`), drifting from the darwin generation. On the Mac, always use `darwin-rebuild`.

### Module Organization

The configuration is split into topic-based modules that are imported by host configurations:

- `home.nix` - Core packages and base configuration (applies to all hosts)
- `shell.nix` - Shell programs (bash, fish, zellij), CLI tools, environment variables, and aliases
- `git.nix` - Git configuration with extensive aliases and settings
- `emacs.nix` - Emacs configuration
- `gnome.nix` - GNOME desktop environment settings
- `myrepos.nix` - Repository management configuration
- `linux.nix` - Linux-specific settings including sops-nix for secrets management
- `macos.nix` - Darwin system configuration (system packages, Tailscale, Nix settings for macOS). This is a nix-darwin system module used in `darwinConfigurations`, not a home-manager module.
- `work.laptop/gryan.nix` - Work-specific configuration for gryan (imported by the Mac config via `homeModules.macos`)
- `tower.desktop/grdryn.nix` - Host-specific home-manager configuration for desktop

Host configurations selectively import modules based on their needs (e.g., work laptop doesn't import `linux.nix`). The macOS config uses a `homeModules.macos` definition that imports `mac-app-util`, `home.nix`, `shell.nix`, `emacs.nix`, `git.nix`, `myrepos.nix`, and `work.laptop/gryan.nix`. The `mac-app-util` module makes Nix-installed GUI apps visible in Spotlight.

### Secrets Management

The configuration uses two approaches for managing secrets:

**sops-nix** - For runtime secrets (passwords, API keys):
- Secrets are stored encrypted in `secrets/` directory
- Age key file location: `~/.config/sops/age/keys.txt`
- Default secrets file: `secrets/secrets.yaml`
- Git-related secrets are included via `linux.nix` into git config
- Secrets are decrypted at activation time (during `home-manager switch`)

**git-crypt** - For encrypting entire configuration files:
- Used for host-specific configs that contain sensitive info but need to be available at build time
- Files marked for encryption in `.gitattributes`
- Currently encrypts: `work.laptop/gryan.nix`
- Encrypted in git repository, plain text in working directory
- Uses symmetric key stored in `.git/git-crypt/keys/default` (local only)
- To unlock on a new machine: `git-crypt unlock /path/to/keyfile`

## Common Commands

### Applying Configuration

The current machine is macOS (`gryan-mac`), so use:

```bash
# Rebuild Darwin system config (includes home-manager via darwinModules).
# This is the ONLY activation path for the Mac.
darwin-rebuild switch --flake .#gryan-mac

# For desktop: home-manager is the primary activation (no system-manager).
home-manager switch --flake .#grdryn@aorus-desktop

# With backup (creates backup with 'bak' extension)
home-manager switch --flake .#grdryn@aorus-desktop -b bak
```

Rule of thumb per host:
- `gryan-mac` → always `darwin-rebuild switch --flake .#gryan-mac`
- `aorus-desktop` → `home-manager switch --flake .#grdryn@aorus-desktop` (primary); Nix daemon managed via official installer

### Why `home-manager` is not on PATH on the Mac

`programs.home-manager.enable = true` (`home.nix`) only installs the `home-manager` CLI when home-manager runs standalone. When home-manager runs as a module — nix-darwin on the Mac — `submoduleSupport.enable` is set and the CLI is intentionally omitted; activation flows through the parent system manager instead. Consequences:

- `gryan-mac`: no `home-manager` binary; use `darwin-rebuild`
- `aorus-desktop`: `home-manager` binary available (standalone); use `home-manager switch`

### Building and Testing

```bash
# Build configuration without activating (test for errors)
home-manager build --flake .#grdryn@aorus-desktop

# Show what would be built (dry run)
home-manager build --flake .#grdryn@aorus-desktop --dry-run

# Alternative: using nix commands directly
nix build .#homeConfigurations.grdryn@aorus-desktop.activationPackage
```

### Flake Management

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake update nixpkgs

# Check flake for errors
nix flake check

# Show flake metadata
nix flake metadata

# Show flake outputs
nix flake show
```

## Key Configuration Details

### Package Management

- Home modules must NOT set `nixpkgs.*` options: `home-manager.useGlobalPkgs = true` on both hosts makes it a hard error (home-manager ≥ 26.11)
- Unfree policy lives at system level: Mac allows unfree packages and installs `claude-code` via `macos.nix`; aorus uses `allowUnfree = false` plus `allowUnfreePredicate` in `tower.desktop/system.nix:25-34`; standalone aorus fast loop sets printer-driver predicate in `flake.nix`
- Packages are installed via `home.packages` in `home.nix`
- Linux-specific packages are added in `linux.nix`

### Shell Configuration

- Default shell: Fish (configured in `zellij` settings)
- Bash is also configured with completion and history
- Key tools enabled: direnv, starship prompt, zoxide, eza, atuin, bat
- Important environment variables in `shell.nix:21-30`:
  - `DOCKER_HOST` points to Podman socket

### Git Configuration

Extensive git alias collection in `git.nix`. Key aliases:
- `s` - status with short format
- `lg` - graphical log with decorations
- `cam` - commit all with message
- `pur` - pull with rebase
- Signing enabled with SSH key (`~/.ssh/id_ed25519`)

### aorus-desktop (Fedora) Nix daemon specifics

- Nix daemon installed via official installer (`sh <(curl -L https://nixos.org/nix/install) --daemon`). Manages `/etc/nix/nix.conf`, systemd units (`nix-daemon.service`, `nix-daemon.socket`), and SELinux contexts.
- SELinux is Enforcing. Nix store binaries are unlabeled (`default_t`), so systemd (`init_t`) may get denials when starting `nix-daemon.service`. Use a domain-based local policy module (`init_t` → `default_t`).

  Definitive module (re)generation — module-removal-first:
  ```bash
  sudo semodule -r my-nix-daemon           # permissive re-exercise only logs
                                             # what the active module DENIES
  sudo setenforce 0
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
  nix build nixpkgs#hello                  # exercise Nix operations
  sudo systemctl restart nix-daemon
  sudo setenforce 1
  sudo ausearch -m avc -ts recent | audit2allow -M my-nix-daemon
  sudo semodule -i my-nix-daemon.pp
  sudo systemctl restart nix-daemon        # verify
  ```

  Rules of the road:
  - Never regenerate from a bare time window — `semodule -i` replaces the whole
    module and silently drops rules whose denials fall outside the window.
  - Archive `my-nix-daemon.te`/`.pp` on the host; extend it for new
    denial classes rather than blind-regenerating.
  - Rules are type-based (`init_t` → `default_t`): new store paths are covered
    automatically; only new permission classes need one more iteration.
  - Exotic future services: run them unconfined instead of growing the policy —
    `systemd.services."<name>".serviceConfig.SELinuxContext = "system_u:system_r:unconfined_service_t:s0";`
- `environment.etc."environment.d/10-system-manager.conf".enable = false` was in `tower.desktop/system.nix` (now deleted): upstream wrote shell-style `${USER}`/`${PATH}` into that file, which environment.d does not expand, poisoning PATH in all sessions (upstream bugs numtide/system-manager#541, fix PR #554 unmerged).
- Fish PATH: herdr/zellij spawn fish without a login-shell profile.d chain, so fish never sees `/etc/profile.d` (nix.sh). `home.sessionPath` in `tower.desktop/grdryn.nix` provides `/nix/var/nix/profiles/default/bin` and the HM profile bin instead. With `useUserPackages = false`, `~/.nix-profile` IS the live HM profile (`home.profileDirectory`) — do not delete it.
- `/etc/nix/nix.conf` should be manually configured post-install for:
  - `experimental-features = nix-command flakes`
  - `trusted-users = root grdryn`
  - Optional substituters: `substituters = https://cache.nixos.org https://numtide.cachix.org`

## Troubleshooting

### Investigating Package Dependencies

To find out why a specific package is being installed:

```bash
# Search for package references in dependency tree
nix-store -q --tree ~/.nix-profile | grep <package-name>

# Find what packages depend on a specific package
nix-store -q --referrers /nix/store/<hash>-<package-name> | xargs -I {} basename {}
```

Example: To find why `python3.12-manim` is installed, the dependency chain is:
`home.nix` → `git-sim` → `python3.12-manim`

## Important Notes

- SSH config is managed via home-manager but requires special permissions handling (see `shell.nix:183-186`)
- The `result` symlink in the repository root points to the built home-manager generation
- Secrets should never be committed - use sops-nix encryption
- When adding new hosts, create a new host-specific configuration file and add it to `flake.nix` outputs
