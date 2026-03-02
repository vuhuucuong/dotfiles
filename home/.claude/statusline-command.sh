#!/bin/sh

# --- config ---
CACHE_FILE="/tmp/.claude_usage_cache"
TZ_CACHE_FILE="/tmp/.claude_tz_cache"

# --- colors (Catppuccin Mocha palette) ---
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_DIM="\033[2m"
C_OVERLAY="\033[38;2;108;112;134m"   # separator / muted
C_PEACH="\033[38;2;250;179;135m"     # model
C_TEAL="\033[38;2;148;226;213m"      # folder
C_MAUVE="\033[38;2;203;166;247m"     # branch
C_YELLOW="\033[38;2;249;226;175m"    # 5h label
C_SAPPHIRE="\033[38;2;116;199;236m"  # 7d label
C_GREEN="\033[38;2;166;227;161m"     # ctx label
C_SUBTEXT="\033[38;2;166;173;200m"   # values
SEP="${C_OVERLAY} • ${C_RESET}"

# ══════════════════════════════════════════════════
#  Helper functions
# ══════════════════════════════════════════════════

# Fetch UTC offset in seconds from time.now API, cached in /tmp until reboot.
fetch_utc_offset() {
  if [ -f "$TZ_CACHE_FILE" ]; then cat "$TZ_CACHE_FILE"; return; fi
  response=$(curl -sf --max-time 3 "https://time.now/developer/api/ip" 2>/dev/null) || { echo 0; return; }
  raw=$(echo "$response" | jq -r '.utc_offset // "+00:00"')
  case "$raw" in -*) _sign=-1 ;; *) _sign=1 ;; esac
  _abs=$(echo "$raw" | sed 's/^[+-]//')
  _hh=$(echo "$_abs" | cut -d: -f1 | sed 's/^0*//' )
  _mm=$(echo "$_abs" | cut -d: -f2 | sed 's/^0*//' )
  _offset=$(( _sign * (${_hh:-0} * 3600 + ${_mm:-0} * 60) ))
  echo "$_offset" > "$TZ_CACHE_FILE"
  echo "$_offset"
}

# Parse an ISO 8601 timestamp to epoch seconds.
# Strips fractional seconds, tries GNU date then BSD date.
iso_to_epoch() {
  clean=$(echo "$1" | sed 's/\.[0-9]*//' | sed 's/[+-][0-9][0-9]:[0-9][0-9]$//' | sed 's/Z$//')
  date -u -d "${clean}" "+%s" 2>/dev/null \
    || date -j -f "%Y-%m-%dT%H:%M:%S" "$clean" "+%s" 2>/dev/null
}

# Given an ISO reset timestamp, print a human-readable countdown (e.g. "2h 15m").
format_countdown() {
  reset_epoch=$(iso_to_epoch "$1")
  [ -n "$reset_epoch" ] || return
  now_epoch=$(date -u "+%s")
  diff=$(( reset_epoch - now_epoch ))
  if [ "$diff" -le 0 ]; then echo "now"; return; fi
  days=$(( diff / 86400 ))
  hours=$(( (diff % 86400) / 3600 ))
  minutes=$(( (diff % 3600) / 60 ))
  if [ "$days" -gt 0 ]; then
    echo "${days}d ${hours}h"
  elif [ "$hours" -gt 0 ]; then
    echo "${hours}h ${minutes}m"
  else
    echo "${minutes}m"
  fi
}

# Given an ISO reset timestamp and period ("5h" or "7d"), print the local wall-clock reset time.
# "5h" → "7:45 AM"   "7d" → "01/Mar at 2PM"
format_reset_at() {
  clean=$(echo "$1" | sed 's/\.[0-9]*//')
  reset_epoch=$(date -d "${clean}" "+%s" 2>/dev/null \
             || date -j -f "%Y-%m-%dT%H:%M:%S%z" "$clean" "+%s" 2>/dev/null)
  [ -n "$reset_epoch" ] || return
  adj_epoch=$(( reset_epoch + _utc_offset ))
  if [ "$2" = "5h" ]; then
    date -u -d "@$adj_epoch" +"%I:%M %p" 2>/dev/null | sed 's/^0//' \
      || date -u -r "$adj_epoch" +"%I:%M %p" 2>/dev/null | sed 's/^0//'
  else
    date -u -d "@$adj_epoch" +"%d/%b at %I%p" 2>/dev/null | sed 's/ at 0/ at /' \
      || date -u -r "$adj_epoch" +"%d/%b at %I%p" 2>/dev/null | sed 's/ at 0/ at /'
  fi
}

# ══════════════════════════════════════════════════
#  Data extraction
# ══════════════════════════════════════════════════

# Extract model name, directory, and git branch from JSON input.
parse_session_info() {
  model=$(echo "$input" | jq -r '.model.display_name // ""')
  dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
  dir_name=$(basename "$dir")
  branch=""
  if [ -d "${dir}/.git" ] || git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null \
          || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  fi
}

# Read cached usage stats (5h / 7d) or trigger a background fetch.
load_usage_cache() {
  five_h="" ; seven_d="" ; five_h_reset="" ; seven_d_reset=""
  if [ -f "$CACHE_FILE" ]; then
    five_h=$(sed -n '1p' "$CACHE_FILE")
    seven_d=$(sed -n '2p' "$CACHE_FILE")
    five_h_reset=$(sed -n '3p' "$CACHE_FILE")
    seven_d_reset=$(sed -n '4p' "$CACHE_FILE")
  else
    bash ~/.claude/fetch-usage.sh > /dev/null 2>&1 &
  fi
}

# Extract context window usage from JSON input.
parse_context_window() {
  ctx_str="—" ; ctx_tokens_str=""
  used=$(echo "$input" | jq -r 'if .context_window.used_percentage != null then .context_window.used_percentage else "" end')
  [ -n "$used" ] || return
  used_int=$(printf "%.0f" "$used")
  ctx_str="${used_int}%"
  ctx_used=$(echo "$input" | jq -r '(.context_window.current_usage.cache_read_input_tokens + .context_window.current_usage.cache_creation_input_tokens + .context_window.current_usage.input_tokens + .context_window.current_usage.output_tokens) // empty' 2>/dev/null)
  ctx_total=$(echo "$input" | jq -r '.context_window.context_window_size // empty' 2>/dev/null)
  if [ -n "$ctx_used" ] && [ -n "$ctx_total" ]; then
    ctx_tokens_str="$(( ctx_used / 1000 ))k/$(( ctx_total / 1000 ))k"
  fi
}

# ══════════════════════════════════════════════════
#  Output rendering
# ══════════════════════════════════════════════════

# Print: [model] • folder • branch
render_header() {
  printf "${C_PEACH}${C_BOLD}[%s]${C_RESET}" "$model"
  printf "%b" "$SEP"
  printf "${C_BOLD}${C_TEAL}%s${C_RESET}" "$dir_name"
  if [ -n "$branch" ]; then
    printf "%b" "$SEP"
    printf "${C_BOLD}${C_MAUVE}%s${C_RESET}" "$branch"
  fi
}

# Print a single usage row.
# $1=label  $2=label_color  $3=percentage  $4=reset_timestamp  $5=period("5h"|"7d")
render_usage_row() {
  printf "${2}[%s]${C_RESET}" "$1"
  printf "${C_OVERLAY}: ${C_RESET}"
  printf "${C_SUBTEXT}%s%%${C_RESET}" "$3"
  [ -n "$4" ] || return
  delta=$(format_countdown "$4")
  reset_at=$(format_reset_at "$4" "$5")
  [ -n "$delta" ] || return
  printf "${C_OVERLAY} | ${C_RESET}"
  if [ -n "$reset_at" ]; then
    printf "${C_DIM}${C_SUBTEXT}(%s - %s)${C_RESET}" "$delta" "$reset_at"
  else
    printf "${C_DIM}${C_SUBTEXT}(%s)${C_RESET}" "$delta"
  fi
}

# Print usage lines (5h and 7d).
render_usage() {
  printf "\n"
  [ -n "$five_h" ] && render_usage_row "5h" "$C_YELLOW" "$five_h" "$five_h_reset" "5h"
  if [ -n "$seven_d" ]; then
    printf "\n"
    render_usage_row "7d" "$C_SAPPHIRE" "$seven_d" "$seven_d_reset" "7d"
  fi
}

# Print context window line.
render_context() {
  printf "\n"
  [ -n "$ctx_str" ] || return
  printf "${C_GREEN}[ctx]${C_RESET}"
  printf "${C_OVERLAY}: ${C_RESET}"
  printf "${C_SUBTEXT}%s${C_RESET}" "$ctx_str"
  if [ -n "$ctx_tokens_str" ]; then
    printf "${C_OVERLAY} | ${C_RESET}"
    printf "${C_DIM}${C_SUBTEXT}(%s)${C_RESET}" "$ctx_tokens_str"
  fi
}

# ══════════════════════════════════════════════════
#  Main
# ══════════════════════════════════════════════════

input=$(cat)
_utc_offset=$(fetch_utc_offset)

parse_session_info
load_usage_cache
parse_context_window

render_header
render_usage
render_context
