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

stow "$F" -v --dotfiles -t "$HOME" 'home'
sudo stow "$F" -v -t '/usr/local/bin' 'bin'
