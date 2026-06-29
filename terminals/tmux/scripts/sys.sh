#!/usr/bin/env bash
set -euo pipefail

tmux_option() {
  local option=$1
  local default=$2
  local value

  value=$(tmux show-option -gqv "$option" 2>/dev/null || true)
  printf '%s' "${value:-$default}"
}

cpu_icon=$(tmux_option '@sys_cpu_icon' '')
gpu_icon=$(tmux_option '@sys_gpu_icon' '󱙺')
ram_icon=$(tmux_option '@sys_ram_icon' '')

timeout_command() {
  if command -v timeout >/dev/null 2>&1; then
    timeout 1s "$@"
  elif command -v gtimeout >/dev/null 2>&1; then
    gtimeout 1s "$@"
  else
    return 127
  fi
}

color_for_percentage() {
  local value=${1%.*}
  if (( value >= 95 )); then
    printf 'brightred'
  elif (( value >= 80 )); then
    printf 'red'
  elif (( value >= 65 )); then
    printf 'magenta'
  elif (( value >= 50 )); then
    printf 'yellow'
  elif (( value >= 35 )); then
    printf 'white'
  elif (( value >= 20 )); then
    printf 'blue'
  elif (( value > 5 )); then
    printf 'green'
  else
    printf 'brightgreen'
  fi
}

cpu_percentage() {
  local cores total
  if command -v sysctl >/dev/null 2>&1; then
    cores=$(sysctl -n hw.logicalcpu 2>/dev/null || printf '1')
  elif command -v nproc >/dev/null 2>&1; then
    cores=$(nproc 2>/dev/null || printf '1')
  else
    cores=1
  fi

  total=$(ps -A -o %cpu= 2>/dev/null | awk '{sum += $1} END {printf "%.0f", sum}')
  awk -v total="${total:-0}" -v cores="${cores:-1}" 'BEGIN {
    if (cores < 1) cores = 1
    value = total / cores
    if (value > 100) value = 100
    printf "%.0f", value
  }'
}

gpu_percentage() {
  local value

  if command -v nvidia-smi >/dev/null 2>&1; then
    value=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null \
      | awk 'NF { sum += $1; count++ } END { if (count > 0) printf "%.0f", sum / count }')
    [[ -n ${value:-} ]] && printf '%s' "$value"
    return 0
  fi

  if command -v intel_gpu_top >/dev/null 2>&1; then
    value=$(timeout_command intel_gpu_top -J -s 250 2>/dev/null \
      | awk -F '[:,]' '/"Render\/3D\/0"/ { getline; gsub(/[^0-9.]/, "", $2); if ($2 != "") { printf "%.0f", $2; exit } }' || true)
    [[ -n ${value:-} ]] && printf '%s' "$value"
    return 0
  fi

  if command -v radeontop >/dev/null 2>&1; then
    value=$(timeout_command radeontop -d - -l 1 2>/dev/null \
      | awk -F '[,%]' '/gpu/ { for (i = 1; i <= NF; i++) if ($i ~ /gpu/) { gsub(/[^0-9.]/, "", $(i + 1)); printf "%.0f", $(i + 1); exit } }' || true)
    [[ -n ${value:-} ]] && printf '%s' "$value"
    return 0
  fi

  return 0
}

ram_percentage() {
  if [[ $(uname -s) == Darwin ]] && command -v vm_stat >/dev/null 2>&1; then
    vm_stat | awk '
      /page size of/ { gsub(/\./, "", $8); page_size = $8 }
      /Pages active/ { active = $3 }
      /Pages inactive/ { inactive = $3 }
      /Pages speculative/ { speculative = $3 }
      /Pages wired down/ { wired = $4 }
      /Pages occupied by compressor/ { compressed = $5 }
      /Pages free/ { free = $3 }
      END {
        gsub(/\./, "", active); gsub(/\./, "", inactive); gsub(/\./, "", speculative)
        gsub(/\./, "", wired); gsub(/\./, "", compressed); gsub(/\./, "", free)
        used = active + wired + compressed
        total = used + inactive + speculative + free
        if (total <= 0) total = 1
        printf "%.0f", used * 100 / total
      }'
  elif [[ -r /proc/meminfo ]]; then
    awk '
      /MemTotal:/ { total = $2 }
      /MemAvailable:/ { available = $2 }
      END {
        if (total <= 0) total = 1
        printf "%.0f", (total - available) * 100 / total
      }' /proc/meminfo
  else
    printf '0'
  fi
}

battery_metrics() {
  local percentage status icon color

  if command -v pmset >/dev/null 2>&1; then
    percentage=$(pmset -g batt 2>/dev/null | awk '/[0-9]+%/ { match($0, /[0-9]+%/); print substr($0, RSTART, RLENGTH - 1); exit }')
    [[ -n ${percentage:-} ]] || return 0
  elif compgen -G '/sys/class/power_supply/BAT*' >/dev/null; then
    local bat
    bat=$(compgen -G '/sys/class/power_supply/BAT*' | head -n 1)
    percentage=$(<"$bat/capacity")
    status=$(<"$bat/status")
  else
    return 0
  fi

  status=${status:-}
  case $percentage in
    ''|*[!0-9]*) return 0 ;;
  esac

  if (( percentage >= 95 )); then
    icon='󰂂'; color='brightgreen'
  elif (( percentage >= 80 )); then
    icon='󰂀'; color='green'
  elif (( percentage >= 65 )); then
    icon='󰁿'; color='blue'
  elif (( percentage >= 50 )); then
    icon='󰁿'; color='white'
  elif (( percentage >= 35 )); then
    icon='󰁽'; color='yellow'
  elif (( percentage >= 20 )); then
    icon='󰁼'; color='magenta'
  elif (( percentage > 5 )); then
    icon='󰁺'; color='red'
  else
    icon='󰂎'; color='brightred'
  fi

  if [[ $status == Charging ]]; then
    icon='󰂄'
  fi

  printf '#[fg=%s,bg=default]%s %3d%% ' "$color" "$icon" "$percentage"
}

cpu=$(cpu_percentage)
gpu=$(gpu_percentage)
ram=$(ram_percentage)

printf '#[fg=%s,bg=default]%s %3d%% ' "$(color_for_percentage "$cpu")" "$cpu_icon" "$cpu"
if [[ -n ${gpu:-} ]]; then
  printf '#[fg=%s,bg=default]%s %3d%% ' "$(color_for_percentage "$gpu")" "$gpu_icon" "$gpu"
fi
printf '#[fg=%s,bg=default]%s %3d%% ' "$(color_for_percentage "$ram")" "$ram_icon" "$ram"
battery_metrics
