#!/usr/bin/env bash
# Claude Code status line: model name + context usage progress bar + weekly usage

input=$(cat)

reset="\033[0m"
dim="\033[2m"

# color for a 0-100 usage percentage: green <70, yellow <90, red >=90
usage_color() {
  local pct="$1"
  if [ "$pct" -ge 90 ]; then
    echo "\033[31m"
  elif [ "$pct" -ge 70 ]; then
    echo "\033[33m"
  else
    echo "\033[32m"
  fi
}

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

used_int=$(printf '%.0f' "$used" 2>/dev/null)
[ -z "$used_int" ] && used_int=0
[ "$used_int" -lt 0 ] && used_int=0
[ "$used_int" -gt 100 ] && used_int=100

width=20
filled=$(( used_int * width / 100 ))
empty=$(( width - filled ))

color=$(usage_color "$used_int")

bar_filled=$(printf '%*s' "$filled" '' | tr ' ' '#')
bar_empty=$(printf '%*s' "$empty" '' | tr ' ' '-')

line=$(printf "${dim}%s${reset} ${dim}[${reset}${color}%s${reset}${dim}%s${reset}${dim}]${reset} ${dim}%s%%${reset}" \
  "$model" "$bar_filled" "$bar_empty" "$used_int")

# weekly usage allowance (Pro/Max subscribers only; may be absent)
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$week" ]; then
  week_int=$(printf '%.0f' "$week" 2>/dev/null)
  if [ -n "$week_int" ]; then
    [ "$week_int" -lt 0 ] && week_int=0
    [ "$week_int" -gt 100 ] && week_int=100
    week_color=$(usage_color "$week_int")
    week_seg=$(printf "${dim}wk ${reset}${week_color}%s%%${reset}" "$week_int")
    line="${line} ${week_seg}"
  fi
fi

printf "%s\n" "$line"
