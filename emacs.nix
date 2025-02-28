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
{ pkgs, misc, ... }:
{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    startWithUserSession = true;
    client = {
      enable = true;
      arguments =  [
        "-c"
      ];
    };
  };

  programs.emacs = {
    enable = true;
    package = with pkgs; (
      (emacsPackagesFor emacs30-pgtk).emacsWithPackages (
        epkgs: with epkgs; [
          adoc-mode
          ag
          ansible-vault
          anzu
          archive-rpm
          beacon
          browse-kill-ring
          cargo
          company-anaconda
          company-ansible
          company-go
          consult
          counsel
          crux
          csv-mode
          cython-mode
          dap-mode
          dhall-mode
          diff-hl
          diminish
          discover-my-major
          dockerfile-mode
          easy-kill
          editorconfig
          elisp-slime-nav
          emacsql
          epl
          exec-path-from-shell
          expand-region
          fira-code-mode
          flycheck-golangci-lint
          flycheck-rust
          forge
          geiser
          gist
          git-modes
          git-timemachine
          gnu-elpa-keyring-update
          go-projectile
          go-snippets
          golint
          gotest
          groovy-mode
          guru-mode
          haskell-mode
          helm-ag
          helm-descbinds
          helm-lsp
          helm-projectile
          helm-rg
          hl-todo
          imenu-anywhere
          inf-ruby
          js2-mode
          json-mode
          keycast
          lsp-java
          lsp-metals
          lsp-pyright
          lsp-ui
          magit-delta
          move-text
          nix-mode
          nlinum
          operate-on-number
          orderless
          pcap-mode
          pinentry
          poly-ansible
          poly-erb
          racket-mode
          rainbow-delimiters
          rainbow-mode
          ron-mode
          rust-mode
          scala-mode
          scss-mode
          smartparens
          smartrep
          super-save
          tide
          transient
          tree-sitter
          tree-sitter-langs
          tsc
          typescript-mode
          undo-tree
          vertico
          volatile-highlights
          vterm
          web-mode
          which-key
          yari
          zenburn-theme
          zop-to-char
        ]
      )
    );
  };
}
