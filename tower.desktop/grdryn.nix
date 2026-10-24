/*
  Copyright 2024 Gerard Ryan

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
  pkgs,
  misc,
  ...
}:
{

  home.username = "grdryn";
  home.homeDirectory = "/var/home/grdryn";

  targets.genericLinux.enable = true;

  sops = {
    secrets.openrouter_api_key.sopsFile = ../secrets/openrouter.yaml;
    templates."openrouter-env".content = ''
      export OPENROUTER_API_KEY="${config.sops.placeholder.openrouter_api_key}"
    '';
  };

  home.file.".envrc".text = ''
    source "${config.sops.templates."openrouter-env".path}"
  '';

  programs.opencode = {
    settings = {
      providers = {
        openrouter = {
          settings.apiKey = "{env:OPENROUTER_API_KEY}";
        };
      };
    };
  };

  # fish is spawned by herdr/zellij without a login-shell profile.d chain,
  # so it never sees the system nix paths. Make it
  # self-sufficient via HM session vars (sourced by HM's config.fish).
  home.sessionPath = [
    "/nix/var/nix/profiles/default/bin"
    "${config.home.profileDirectory}/bin"
  ];

  home.packages = with pkgs; [
    mfcl8690cdwcupswrapper
  ];

  services.mpd = {
    enable = true;
    network.listenAddress = "aorus";
  };

  services.mpd-mpris = {
    enable = true;
  };

  services.mpdscribble = {
    enable = true;
    endpoints = {
      "last.fm" = {
        username = "grdryn";
        passwordFile = "${config.home.homeDirectory}/.config/sops-nix/secrets/lastfm_password";
      };
      "libre.fm" = {
        username = "grdryn";
        passwordFile = "${config.home.homeDirectory}/.config/sops-nix/secrets/librefm_password";
      };
    };
    journalInterval = 60;
  };
}
