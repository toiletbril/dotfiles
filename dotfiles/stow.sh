#!/bin/sh

set -eu

cd "$(dirname "$(realpath "$0")")" || exit 1

V="-v"

case "${1:-}" in
  'install')   F='-S';;
  'delete')    F='-D';;
  'reinstall') F='-R';;
*)
  echo "$0 install/delete/reinstall" >&2
  exit 1
esac

stow "$F" "$V" --dotfiles -t "$HOME" 'home'

# special case: zen profiles and userChrome.css
(
  set -x
  cd "$HOME"/.zen/
  # cp dereferences the symlink.
  find . -maxdepth 2 -name 'chrome' -exec cp ./userChrome.css {} \;
  unlink ./userChrome.css
)
# special case: Code - OSS
(
  set -x
  cd "$HOME"/.config
  ln -sf vscode 'Code - OSS'
)

sudo stow "$F" "$V" -t '/usr/local/bin' 'bin'
