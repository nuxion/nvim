#!/usr/bin/env bash
# Perform the updates that nvim-status.sh reports.
#
#   nvim-update.sh                 # everything, after confirmation
#   nvim-update.sh -y              # no confirmation
#   nvim-update.sh plugins mason   # only the named layers
#
# Layers: plugins | mason | parsers.  System packages (pacman) are never
# touched here — they need sudo, run `sudo pacman -Syu` yourself.
set -uo pipefail

NVIM_CONFIG="${NVIM_CONFIG:-$HOME/.config/nvim}"
bold=$(tput bold 2>/dev/null || true); reset=$(tput sgr0 2>/dev/null || true)

assume_yes=0
layers=()
for a in "$@"; do
  case "$a" in
    -y|--yes)  assume_yes=1 ;;
    plugins|mason|parsers) layers+=("$a") ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \?//'; exit 0 ;;
    *) printf 'unknown argument: %s (try --help)\n' "$a" >&2; exit 2 ;;
  esac
done
[ ${#layers[@]} -eq 0 ] && layers=(plugins mason parsers)

wants() { printf '%s\n' "${layers[@]}" | grep -qx "$1"; }
step()  { printf '\n%s== %s%s\n' "$bold" "$1" "$reset"; }

if [ "$assume_yes" -eq 0 ]; then
  printf 'About to update: %s\n' "${layers[*]}"
  read -r -p 'Continue? [y/N] ' reply
  case "$reply" in [yY]*) ;; *) echo "aborted"; exit 0 ;; esac
fi

# Snapshot the lockfile so a bad update can be rolled back.
if wants plugins && [ -f "$NVIM_CONFIG/lazy-lock.json" ]; then
  cp "$NVIM_CONFIG/lazy-lock.json" "$NVIM_CONFIG/lazy-lock.json.bak"
  printf 'lockfile backed up to lazy-lock.json.bak\n'
fi

run_nvim() {  # run headless nvim with a time limit, strip ANSI
  timeout "$1" nvim --headless "${@:2}" 2>&1 | sed 's/\x1b\[[0-9;]*m//g'
}

if wants plugins; then
  step "Plugins (lazy.nvim)"
  run_nvim 600 "+Lazy! update" +qa | grep -Ei 'error|updated|Total' | tail -20
fi

if wants mason; then
  step "Tools (mason)"
  tmp=$(mktemp --suffix=.lua)
  cat > "$tmp" <<'LUA'
-- Refresh the registry, then install the latest build of every package that is
-- already installed. mason's install() replaces the existing version in place.
local reg = require("mason-registry")
reg.update(function()
  local pkgs = reg.get_installed_packages()
  local pending = #pkgs
  if pending == 0 then print("no packages installed") vim.cmd("qa!") return end
  for _, p in ipairs(pkgs) do
    local handle = p:install()
    handle:once("closed", function()
      print((p:is_installed() and "ok   " or "FAIL ") .. p.name)
      pending = pending - 1
      if pending == 0 then vim.schedule(function() vim.cmd("qa!") end) end
    end)
  end
end)
vim.wait(900000, function() return false end)
LUA
  timeout 900 nvim --headless -c "luafile $tmp" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep -E '^(ok|FAIL|no packages)' 
  rm -f "$tmp"
fi

if wants parsers; then
  step "Tree-sitter parsers"
  # `TSUpdate` rebuilds every installed parser whose pinned revision moved.
  run_nvim 900 "+TSUpdate" -c "sleep 5" +qa | tail -10
  printf 'done (parser revisions rechecked)\n'
fi

step "Result"
"$NVIM_CONFIG/scripts/nvim-status.sh"
