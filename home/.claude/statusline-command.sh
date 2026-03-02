#!/bin/sh
input=$(cat)

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // ""')

# --- folder ---
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir_name=$(basename "$dir")

# --- git branch ---
branch=""
if [ -d "${dir}/.git" ] || git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
fi

# --- usage stats (5h / 7d) from cache ---
CACHE_FILE="/tmp/.claude_usage_cache"
five_h=""
seven_d=""
five_h_reset=""
seven_d_reset=""

if [ -f "$CACHE_FILE" ]; then
  five_h=$(sed -n '1p' "$CACHE_FILE")
  seven_d=$(sed -n '2p' "$CACHE_FILE")
  five_h_reset=$(sed -n '3p' "$CACHE_FILE")
  seven_d_reset=$(sed -n '4p' "$CACHE_FILE")
else
  bash ~/.claude/fetch-usage.sh > /dev/null 2>&1 &
fi

# --- compute_delta: given a raw ISO timestamp, returns human-readable time until reset ---
compute_delta() {
  clean=$(echo "$1" | sed 's/\.[0-9]*//' | sed 's/[+-][0-9][0-9]:[0-9][0-9]$//' | sed 's/Z$//')
  # Try GNU date (Linux) first, then BSD date (macOS)
  reset_epoch=$(date -u -d "${clean}" "+%s" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "$clean" "+%s" 2>/dev/null)
  if [ -z "$reset_epoch" ]; then return; fi
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

# --- format_reset_at: given a raw ISO timestamp and period type, returns wall-clock reset time ---
# period: "5h" → "7:45 AM"   "7d" → "01/Mar at 2AM"
# Relies on _utc_offset (seconds east of UTC) computed once in the assemble section.
format_reset_at() {
  clean=$(echo "$1" | sed 's/\.[0-9]*//')
  reset_epoch=$(date -d "${clean}" "+%s" 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S%z" "$clean" "+%s" 2>/dev/null)
  if [ -z "$reset_epoch" ]; then return; fi
  adj_epoch=$(( reset_epoch + _utc_offset ))
  if [ "$2" = "5h" ]; then
    date -u -d "@$adj_epoch" +"%I:%M %p" 2>/dev/null | sed 's/^0//' \
      || date -u -r "$adj_epoch" +"%I:%M %p" 2>/dev/null | sed 's/^0//'
  else
    date -u -d "@$adj_epoch" +"%d/%b at %I%p" 2>/dev/null | sed 's/ at 0/ at /' \
      || date -u -r "$adj_epoch" +"%d/%b at %I%p" 2>/dev/null | sed 's/ at 0/ at /'
  fi
}

# --- context window ---
used=$(echo "$input" | jq -r 'if .context_window.used_percentage != null then .context_window.used_percentage else "" end')
ctx_str="—"
ctx_tokens_str=""
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  ctx_str="${used_int}%"
  ctx_used=$(echo "$input" | jq -r '(.context_window.current_usage.cache_read_input_tokens + .context_window.current_usage.cache_creation_input_tokens + .context_window.current_usage.input_tokens + .context_window.current_usage.output_tokens) // empty' 2>/dev/null)
  ctx_total=$(echo "$input" | jq -r '.context_window.context_window_size // empty' 2>/dev/null)
  if [ -n "$ctx_used" ] && [ -n "$ctx_total" ]; then
    ctx_used_k=$(( ctx_used / 1000 ))
    ctx_total_k=$(( ctx_total / 1000 ))
    ctx_tokens_str="${ctx_used_k}k/${ctx_total_k}k"
  fi
fi

# --- local UTC offset (seconds east of UTC), cached 6 hours ---
TZ_OFFSET_CACHE="/tmp/.claude_tz_offset"
_utc_offset=0
_tz_cache_fresh=0
if [ -f "$TZ_OFFSET_CACHE" ]; then
  _cache_age=$(( $(date -u +%s) - $(stat -c %Y "$TZ_OFFSET_CACHE" 2>/dev/null || stat -f %m "$TZ_OFFSET_CACHE" 2>/dev/null || echo 0) ))
  [ "$_cache_age" -lt 21600 ] && _tz_cache_fresh=1
fi
if [ "$_tz_cache_fresh" = "1" ]; then
  _utc_offset=$(cat "$TZ_OFFSET_CACHE" 2>/dev/null)
else
  _tz_json=$(curl -s -m 3 "https://time.now/developer/api/ip" 2>/dev/null)
  if [ -n "$_tz_json" ]; then
    _raw=$(printf '%s' "$_tz_json" | jq -r '.raw_offset // ""' 2>/dev/null)
    if [ -n "$_raw" ]; then
      _utc_offset=$_raw
      printf '%s' "$_utc_offset" > "$TZ_OFFSET_CACHE"
    fi
  fi
fi
_utc_offset=${_utc_offset:-0}

# --- assemble output ---
SEP="\033[38;2;108;112;134m • \033[0m"

# line 1: model | folder • branch
printf "\033[38;2;250;179;135m\033[1m[%s]\033[22m\033[0m" "$model"
printf "%b" "$SEP"
printf "\033[1m\033[38;2;148;226;213m%s\033[22m\033[0m" "$dir_name"
if [ -n "$branch" ]; then
  printf "%b" "$SEP"
  printf "\033[1m\033[38;2;203;166;247m%s\033[22m\033[0m" "$branch"
fi

# line 2: usage
printf "\n"
if [ -n "$five_h" ]; then
  printf "\033[38;2;249;226;175m[5h]\033[0m"
  printf "\033[38;2;108;112;134m: \033[0m"
  printf "\033[38;2;166;173;200m%s%%\033[0m" "$five_h"
  if [ -n "$five_h_reset" ]; then
    delta=$(compute_delta "$five_h_reset")
    reset_at=$(format_reset_at "$five_h_reset" "5h")
    if [ -n "$delta" ]; then
      printf "\033[38;2;108;112;134m | \033[0m"
      if [ -n "$reset_at" ]; then
        printf "\033[2m\033[38;2;166;173;200m(%s - %s)\033[0m" "$delta" "$reset_at"
      else
        printf "\033[2m\033[38;2;166;173;200m(%s)\033[0m" "$delta"
      fi
    fi
  fi
fi
if [ -n "$seven_d" ]; then
  printf "\n"
  printf "\033[38;2;116;199;236m[7d]\033[0m"
  printf "\033[38;2;108;112;134m: \033[0m"
  printf "\033[38;2;166;173;200m%s%%\033[0m" "$seven_d"
  if [ -n "$seven_d_reset" ]; then
    delta=$(compute_delta "$seven_d_reset")
    reset_at=$(format_reset_at "$seven_d_reset" "7d")
    if [ -n "$delta" ]; then
      printf "\033[38;2;108;112;134m | \033[0m"
      if [ -n "$reset_at" ]; then
        printf "\033[2m\033[38;2;166;173;200m(%s - %s)\033[0m" "$delta" "$reset_at"
      else
        printf "\033[2m\033[38;2;166;173;200m(%s)\033[0m" "$delta"
      fi
    fi
  fi
fi

# line 3: ctx
printf "\n"
if [ -n "$ctx_str" ]; then
  printf "\033[38;2;166;227;161m[ctx]\033[0m"
  printf "\033[38;2;108;112;134m: \033[0m"
  printf "\033[38;2;166;173;200m%s\033[0m" "$ctx_str"
  if [ -n "$ctx_tokens_str" ]; then
    printf "\033[38;2;108;112;134m | \033[0m"
    printf "\033[2m\033[38;2;166;173;200m(%s)\033[0m" "$ctx_tokens_str"
  fi
fi
