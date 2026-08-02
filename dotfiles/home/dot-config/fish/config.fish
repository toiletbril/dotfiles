set fish_greeting "this is fish!! ><>"

if command -q brew
  set brew_executable (command -s brew)
else if test -x /opt/homebrew/bin/brew
  set brew_executable /opt/homebrew/bin/brew
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
  set brew_executable /home/linuxbrew/.linuxbrew/bin/brew
end

if set -q brew_executable
  eval ($brew_executable shellenv fish)
  set --erase brew_executable
end

if test (uname -s) = Darwin
  alias less=moor
else
  alias less=moar
end

alias ls="lsd --group-directories-first -AF"
alias ll="lsd --group-directories-first -lAhXZF"

# thefuck --alias | source

true
