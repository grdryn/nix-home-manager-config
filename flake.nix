{
  description = "Nix home-manager Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # xhmm
    xhmm.url = "github:schuelermine/xhmm/b0";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, xhmm, ... }@inputs: {

    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {

      "gryan@work.laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          xhmm.homeManagerModules.all
          ./home.nix
          ./shell.nix
          ./emacs.nix
          ./gnome.nix
          ./git.nix
          # Host Specific configs
          ./work.laptop/gryan.nix
        ];
      };

    };
  };
}
