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

     "gryan@work.fedora.vm.aarch64" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          xhmm.homeManagerModules.all
          ./home.nix
          ./linux.nix
          ./shell.nix
          ./emacs.nix
          ./gnome.nix
          ./git.nix
          ./myrepos.nix
          # Host Specific configs
          ./work.laptop/gryan.nix
        ];
      };

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
          ./myrepos.nix
          # Host Specific configs
          ./work.laptop/gryan.nix
        ];
      };

      "grdryn@aorus-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          xhmm.homeManagerModules.all
          ./home.nix
          ./linux.nix
          ./shell.nix
          ./emacs.nix
          ./gnome.nix
          ./git.nix
          ./myrepos.nix
          # Host Specific configs
          ./tower.desktop/grdryn.nix
        ];
      };

    };
  };
}
