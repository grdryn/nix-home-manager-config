# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix home-manager configuration repository that manages user environment, packages, and dotfiles across multiple machines using a flake-based approach. The configuration is modular and supports different host-specific setups.

## Architecture

### Flake Structure

The repository uses Nix flakes with `flake.nix` as the entry point. It defines multiple `homeConfigurations` for different hosts:

- `gryan@work.fedora.vm.aarch64` - ARM64 Linux VM configuration
- `gryan@work.laptop` - x86_64 Linux laptop configuration
- `grdryn@aorus-desktop` - x86_64 Linux desktop configuration

### Module Organization

The configuration is split into topic-based modules that are imported by host configurations:

- `home.nix` - Core packages and base configuration (applies to all hosts)
- `shell.nix` - Shell programs (bash, fish, zellij), CLI tools, environment variables, and aliases
- `git.nix` - Git configuration with extensive aliases and settings
- `emacs.nix` - Emacs configuration
- `gnome.nix` - GNOME desktop environment settings
- `myrepos.nix` - Repository management configuration
- `linux.nix` - Linux-specific settings including sops-nix for secrets management
- `work.laptop/gryan.nix` - Host-specific configuration for work laptop
- `tower.desktop/grdryn.nix` - Host-specific configuration for desktop

Host configurations selectively import modules based on their needs (e.g., work laptop doesn't import `linux.nix`).

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

The current hostname is `work.fedora.vm.aarch64`, so use:

```bash
# Using the convenience alias (defined in shell.nix:44)
apply-work.laptop

# Using home-manager directly for current host (work.fedora.vm.aarch64)
home-manager switch --flake .#gryan@work.fedora.vm.aarch64

# For work laptop
home-manager switch --flake .#gryan@work.laptop

# For desktop
home-manager switch --flake .#grdryn@aorus-desktop

# With backup (creates backup with 'bak' extension)
home-manager switch --flake .#gryan@work.fedora.vm.aarch64 -b bak
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
- Exception: `claude-code` is explicitly allowed as unfree (see `home.nix:29-31`)
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

## Important Notes

- SSH config is managed via home-manager but requires special permissions handling (see `shell.nix:183-186`)
- The `result` symlink in the repository root points to the built home-manager generation
- Secrets should never be committed - use sops-nix encryption
- When adding new hosts, create a new host-specific configuration file and add it to `flake.nix` outputs
