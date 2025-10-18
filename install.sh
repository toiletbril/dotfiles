#!/bin/sh

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
  test -e "$2" && \
  ! test -L "$2" && \
  mv -vf "$2" "$1"
}

mkdir -p './backup/dotfiles'
for F in ./dotfiles/.*; do
  F="$(basename "$F")"
  test -f "./dotfiles/$F" || continue
  back_up "./backup/dotfiles" "$HOME/$F"
  ln -sfv "$(realpath "./dotfiles/$F")" "$HOME/"
done

back_up "./backup/dotfiles" "$HOME/.clang-format"
ln -sfv "$HOME/.clang-format-google" "$HOME/.clang-format"

mkdir -p './backup/.config'
for F in ./.config/*; do
  F="$(basename "$F")"
  back_up "./backup/.config" "$HOME/.config/$F"
  ln -sfv "$(realpath "./.config/$F")" "$HOME/.config/"
done

mkdir -p './backup/usr-local-bin'
for F in ./bin/*; do
  F="$(basename "$F")"
  back_up "./backup/usr-local-bin/" "/usr/local/bin/$F"
  ln -sfv "$(realpath "./bin/$F")" "/usr/local/bin/"
done

chown -R "$ACTUAL_USER" './backup'
