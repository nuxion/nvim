#!/usr/bin/env bash
# Report what is out of date in this Neovim config, without changing anything.
#   Layers: lazy.nvim plugins, Mason tools (LSP/formatters), tree-sitter parsers.
# Exit code: 0 = everything current, 1 = updates available.
set -uo pipefail

NVIM_CONFIG="${NVIM_CONFIG:-$HOME/.config/nvim}"
NVIM_DATA="${NVIM_DATA:-$HOME/.local/share/nvim}"
LOCK="$NVIM_CONFIG/lazy-lock.json"
PLUGIN_DIR="$NVIM_DATA/lazy"

bold=$(tput bold 2>/dev/null || true); dim=$(tput dim 2>/dev/null || true)
reset=$(tput sgr0 2>/dev/null || true)
updates=0

section() { printf '\n%s== %s%s\n' "$bold" "$1" "$reset"; }
none()    { printf '   %sall current%s\n' "$dim" "$reset"; }

# Run a lua snippet inside the real config and strip ANSI noise.
nvim_lua() {
  local tmp; tmp=$(mktemp --suffix=.lua)
  cat > "$tmp"
  timeout 120 nvim --headless -c "luafile $tmp" -c "qa!" 2>&1 | sed 's/\x1b\[[0-9;]*m//g'
  rm -f "$tmp"
}

# ---------------------------------------------------------------- plugins
section "Plugins (lazy.nvim)"
found=0
while IFS=$'\t' read -r name branch; do
  d="$PLUGIN_DIR/$name"
  [ -d "$d/.git" ] || continue
  git -C "$d" fetch -q origin "$branch" 2>/dev/null || continue
  n=$(git -C "$d" rev-list --count HEAD..FETCH_HEAD 2>/dev/null) || continue
  [ "${n:-0}" -gt 0 ] || continue
  found=1; updates=1
  printf '   %-26s %4s commits behind %s  %s(%s)%s\n' "$name" "$n" "$branch" \
    "$dim" "$(git -C "$d" log -1 --format='%ar' FETCH_HEAD)" "$reset"
done < <(python3 -c "
import json, sys
for k, v in json.load(open(sys.argv[1])).items():
    print(k + chr(9) + v.get('branch', 'HEAD'))" "$LOCK")
[ "$found" -eq 0 ] && none

# ------------------------------------------------------------------ mason
section "Tools (mason)"
# Registry version per installed package; the installed version is read from
# each package's receipt below (receipt API shape varies across mason versions).
mason_out=$(nvim_lua <<'LUA'
local ok, reg = pcall(require, "mason-registry")
if not ok then return end
local function ver(purl) return purl and purl:match("@([^@]+)$") or "?" end
reg.update(function()
  for _, p in ipairs(reg.get_installed_packages()) do
    print(("MASON\t%s\t%s"):format(p.name, ver(p.spec.source and p.spec.source.id)))
  end
  vim.cmd("qa!")
end)
vim.wait(60000, function() return false end)
LUA
)
found=0
while IFS=$'\t' read -r tag name want; do
  [ "${tag:-}" = "MASON" ] || continue
  [ "$want" != "?" ] || continue
  receipt="$NVIM_DATA/mason/packages/$name/mason-receipt.json"
  have=$(python3 -c "
import json, sys
# receipt schema 1.x stores the purl under 'primary_source', 2.x under 'source'
try:
    d = json.load(open(sys.argv[1]))
    pid = (d.get('primary_source') or d.get('source') or {})['id']
    print(pid.rsplit('@', 1)[-1] if '@' in pid else '?')
except Exception:
    print('?')" "$receipt")
  [ "$have" = "$want" ] && continue
  found=1; updates=1
  printf '   %-26s %s -> %s\n' "$name" "$have" "$want"
done <<< "$mason_out"
[ "$found" -eq 0 ] && none

# --------------------------------------------------------------- parsers
section "Tree-sitter parsers"
ts_out=$(nvim_lua <<'LUA'
-- nvim-treesitter (main branch) records the installed revision per language in
-- site/parser-info/<lang>.revision; parsers.lua holds the revision it wants.
local ok, P = pcall(require, "nvim-treesitter.parsers")
if not ok then return end
local dir = vim.fn.stdpath("data") .. "/site/parser-info/"
for _, f in ipairs(vim.fn.glob(dir .. "*.revision", false, true)) do
  local lang = vim.fn.fnamemodify(f, ":t:r")
  local have = vim.trim(table.concat(vim.fn.readfile(f), ""))
  local want = P[lang] and P[lang].install_info and P[lang].install_info.revision
  if want and want ~= have then
    print(("TS\t%s\t%s\t%s"):format(lang, have, want))
  end
end
LUA
)
found=0
while IFS=$'\t' read -r tag lang have want; do
  [ "${tag:-}" = "TS" ] || continue
  found=1; updates=1
  printf '   %-26s %s -> %s\n' "$lang" "${have:0:12}" "${want:0:12}"
done <<< "$ts_out"
[ "$found" -eq 0 ] && none

# ---------------------------------------------------------------- system
section "System packages (pacman)"
if command -v checkupdates >/dev/null 2>&1; then
  sys=$(checkupdates 2>/dev/null | grep -E '^(neovim|tree-sitter|luarocks|ripgrep|fd|go|python-pip)( |$)' || true)
else
  sys=$(pacman -Qu 2>/dev/null | grep -E '^(neovim|tree-sitter|luarocks|ripgrep|fd|go)( |$)' || true)
fi
if [ -n "$sys" ]; then
  printf '   %s\n' "$sys"
  printf '   %snot updated by nvim-update.sh — needs: sudo pacman -Syu%s\n' "$dim" "$reset"
else
  none
fi

printf '\n'
if [ "$updates" -eq 1 ]; then
  printf '%sUpdates available.%s Run: %s/scripts/nvim-update.sh\n' "$bold" "$reset" "$NVIM_CONFIG"
  exit 1
fi
printf 'Everything up to date.\n'
