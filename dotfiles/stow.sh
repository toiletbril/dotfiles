#!/bin/sh

set -eu

cd "$(dirname "$(realpath "$0")")" || exit 1

case "${1:-}" in
  'install')   F='-S';;
  'delete')    F='-D';;
  'reinstall') F='-R';;
*)
  echo "$0 install/delete/reinstall" >&2
  exit 1
esac

stow "$F" -v 2 --dotfiles -t "$HOME" 'home'

# special case: zen profiles and userChrome.css
(
  set -x
  cd "$HOME"/.zen/
  # cp dereferences the symlink.
  find . -maxdepth 2 -name 'chrome' -exec cp ./userChrome.css {} \;
  unlink ./userChrome.css
)

sudo stow "$F" -v 2 -t '/usr/local/bin' 'bin'
