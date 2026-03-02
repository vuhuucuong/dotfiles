#!/bin/sh
# Fetches Claude API usage stats and writes them to a cache file.
# Output format (one per line):
#   1: five_hour utilization  (integer %)
#   2: seven_day utilization  (integer %)
#   3: five_hour resets_at    (ISO 8601 timestamp)
#   4: seven_day resets_at    (ISO 8601 timestamp)
# Meant to be run in background; all output is suppressed.

# --- constants ---
CACHE_FILE="/tmp/.claude_usage_cache"
TOKEN_CACHE="/tmp/.claude_token_cache"
CREDS_FILE="$HOME/.claude/.credentials.json"
TOKEN_TTL=900  # 15 minutes

# --- functions ---

# Returns the cached or fresh OAuth access token via stdout.
# Exits the script if no valid token can be obtained.
get_token() {
  # try cached token first
  if [ -f "$TOKEN_CACHE" ]; then
    # GNU stat (Linux) vs BSD stat (macOS)
    mtime=$(stat -c %Y "$TOKEN_CACHE" 2>/dev/null \
         || stat -f %m "$TOKEN_CACHE" 2>/dev/null \
         || echo 0)
    age=$(( $(date -u +%s) - mtime ))
    if [ "$age" -lt "$TOKEN_TTL" ]; then
      cat "$TOKEN_CACHE" 2>/dev/null && return
    fi
  fi

  # read from credentials file
  [ -f "$CREDS_FILE" ] || exit 0
  local_token=$(jq -r '.claudeAiOauth.accessToken // empty' "$CREDS_FILE" 2>/dev/null)
  [ -n "$local_token" ] || exit 0

  printf '%s' "$local_token" > "$TOKEN_CACHE"
  printf '%s' "$local_token"
}

# Calls the Anthropic usage API and prints the raw JSON to stdout.
# Returns non-zero if the request fails or produces empty output.
fetch_usage_json() {
  curl -s -m 3 \
    -H "accept: application/json" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "authorization: Bearer $1" \
    -H "user-agent: claude-code/2.1.11" \
    "https://api.anthropic.com/oauth/usage" 2>/dev/null
}

# Parses the usage JSON and writes the cache file.
# $1 = raw JSON from the API
write_cache() {
  five_h_raw=$(printf '%s' "$1" | jq -r '.five_hour.utilization // empty' 2>/dev/null)
  seven_d_raw=$(printf '%s' "$1" | jq -r '.seven_day.utilization // empty' 2>/dev/null)

  [ -n "$five_h_raw" ] && [ -n "$seven_d_raw" ] || return 1

  five_h_reset=$(printf '%s' "$1" | jq -r '.five_hour.resets_at // ""' 2>/dev/null)
  seven_d_reset=$(printf '%s' "$1" | jq -r '.seven_day.resets_at // ""' 2>/dev/null)

  printf '%s\n%s\n%s\n%s\n' \
    "$(printf '%.0f' "$five_h_raw")" \
    "$(printf '%.0f' "$seven_d_raw")" \
    "$five_h_reset" \
    "$seven_d_reset" > "$CACHE_FILE"
}

# --- main ---

token=$(get_token)
usage_json=$(fetch_usage_json "$token")
[ -n "$usage_json" ] || exit 0
write_cache "$usage_json"
