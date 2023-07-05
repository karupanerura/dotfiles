#!/bin/bash
set -uex

brew tap homebrew/cask-fonts
brew tap microsoft/git
brew install asdf colordiff curl coreutils emacs gh ghq git gnu-units go gojq ipcalc jq peco sqlite vim watch wrk zsh zsh-completions
brew install --cask font-myricam git-credential-manager-core
chmod -R go-w /opt/homebrew/share