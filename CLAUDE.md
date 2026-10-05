# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix home-manager configuration repository that manages user environment, packages, and dotfiles across multiple machines using a flake-based approach. The configuration is modular and supports different host-specific setups.

## Architecture

### Flake Structure

The repository uses Nix flakes with `flake.nix` as the entry point. It defines multiple `homeConfigurations` for different hosts:

- `gryan@gryan-mac` - aarch64-darwin Apple Silicon Mac configuration
- `gryan@work.fedora.vm.aarch64` - ARM64 Linux VM configuration
- `gryan@work.laptop` - x86_64 Linux laptop configuration
- `grdryn@aorus-desktop` - x86_64 Linux desktop configuration

It also defines:
- `darwinConfigurations."gryan-mac"` - system-level macOS configuration via nix-darwin.
- `systemConfigs."aorus-desktop"` - system-level Linux configuration for aorus-desktop via Numtide system-manager (includes home-manager for grdryn).

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
- `work.laptop/gryan.nix` - Host-specific configuration for work laptop
- `tower.desktop/grdryn.nix` - Host-specific home-manager configuration for desktop
- `tower.desktop/system.nix` - System configuration for aorus-desktop via Numtide system-manager

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
# Rebuild Darwin system config (includes home-manager via darwinModules)
darwin-rebuild switch --flake .#gryan-mac

# Or using home-manager directly for mac
home-manager switch --flake .#gryan@gryan-mac

# For ARM64 Linux VM
home-manager switch --flake .#gryan@work.fedora.vm.aarch64

# For work laptop
home-manager switch --flake .#gryan@work.laptop

# For desktop system config via system-manager (includes home-manager)
# Uses the pinned runner app exported by this flake, matching flake.lock
nix run .#system-manager -- switch --flake .#aorus-desktop --sudo

# Or using home-manager directly for desktop
home-manager switch --flake .#grdryn@aorus-desktop

# With backup (creates backup with 'bak' extension)
home-manager switch --flake .#gryan@gryan-mac -b bak
```

### Building and Testing

```bash
# Build configuration without activating (test for errors)
home-manager build --flake .#gryan@work.fedora.vm.aarch64

# Show what would be built (dry run)
home-manager build --flake .#gryan@work.fedora.vm.aarch64 --dry-run

# Alternative: using nix commands directly
nix build .#homeConfigurations.gryan@work.fedora.vm.aarch64.activationPackage
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

- Base policy: `allowUnfree = false` (see `home.nix:23`)
- Exceptions allowed via `allowUnfreePredicate` (see `home.nix:29-35`): `code-cursor`, `cursor`, `claude-code`, `mfcl8690cdwlpr`, `mfcl8690cdwcupswrapper`
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

### aorus-desktop (Fedora) system-manager specifics

- SELinux is Enforcing. system-manager's `/etc/.system-manager-static` tree and unit symlinks land on unlabeled (`default_t`) contexts, so systemd refuses to load units ("Unit ... not found"). One-time host fix (upstream issue numtide/system-manager#115):
  ```bash
  sudo semanage fcontext -a -t systemd_unit_file_t '/etc/\.system-manager-static/systemd(/.*)?'
  sudo restorecon -RvF /etc/.system-manager-static /etc/systemd/system
  sudo restorecon -r /nix/store
  ```
- `environment.etc."environment.d/10-system-manager.conf".enable = false` in `tower.desktop/system.nix`: upstream writes shell-style `${USER}`/`${PATH}` into that file, which environment.d does not expand, poisoning PATH in all sessions (upstream bugs numtide/system-manager#541, fix PR #554 unmerged). The `/etc/profile.d/system-manager-path.sh` variant works correctly and is kept.
- `services.userborn.enable = false` + `home-manager.useUserPackages = false`: the `grdryn` user is managed by Fedora itself, not system-manager. The `users.users.grdryn` entry in `tower.desktop/system.nix` is inert metadata (home-manager's NixOS module reads `users.users.<name>.home` for `home.homeDirectory`).
- Always run switch via `nix run .#system-manager` (pinned to flake.lock), not `nix run github:numtide/system-manager` (unpinned master).

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
