#!/bin/sh

set -u

cd "$(dirname "$(realpath "$0")")" || exit 1

if test -d './backup'; then
  echo "backup exists!!!! only yolo allowed!! delete it the fuck out of here!!!!" >&2
  exit 1
fi

if test "$USER" != "root"; then
  exec sudo ACTUAL_USER="$USER" "$0"
elif test -z "$ACTUAL_USER"; then
  echo "run as ordinary user!!!!!!! and then enter your password!!!!"
  exit 1
fi

# fix the home!!!!!!!11
HOME="/home/$ACTUAL_USER"

back_up() {
  test -e "$2" && ! test -L "$2" && mv -vf "$2" "$1"
}

link_dotfile() {
  # src, target, file
  back_up "./backup/$1" "$2/$3"
  ln -sfv "$(realpath "./$1/$3")" "$2/"
}

mkdir -p './backup/dotfiles'
for F in ./dotfiles/.*; do
  F="$(basename "$F")"
  test -f "./dotfiles/$F" || continue
  link_dotfile "dotfiles" "$HOME" "$F"
done

back_up "./backup/dotfiles" "$HOME/.clang-format"
ln -sfv "$HOME/.clang-format-google" "$HOME/.clang-format"

mkdir -p './backup/.config'
for F in ./.config/*; do
  F="$(basename "$F")"
  case "$F" in
    # copy the individual files as to not interfere with crap software puts in
    # it's config folder.
    'vscode')
      FF="$(cd ./.config/ && find "./$F" -type f)"
      for FFF in $FF; do
        D="$(dirname "$HOME/.config/$FFF")"
        mkdir -p "$D"
        back_up "./backup/.config/" "$HOME/.config/$FFF"
        ln -sfv "$(realpath "./.config/$FFF")" "$HOME/.config/$FFF"
      done
      chown -R "$ACTUAL_USER":"$ACTUAL_USER" "$HOME/.config/$F"
      ;;
    *)
      link_dotfile ".config" "$HOME/.config" "$F"
      ;;
  esac
done

if test -L "$HOME/.config/Code - OSS"; then
  unlink "$HOME/.config/Code - OSS"
else
  back_up "./backup/.config" "$HOME/.config/Code - OSS"
fi
ln -sfv "$HOME/.config/vscode" "$HOME/.config/Code - OSS"

mkdir -p './backup/usr-local-bin'
for F in ./bin/*; do
  F="$(basename "$F")"
  link_dotfile "bin" "/usr/local/bin" "$F"
done

chown -R "$ACTUAL_USER" './backup'
