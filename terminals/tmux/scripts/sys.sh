#!/usr/bin/env bash
set -euo pipefail

# Tiny dependency probe for optional platform tools.
require() { command -v "$1" &>/dev/null; }

tmux_option() {
  local option=$1
  local default=$2
  local value

  value=$(tmux show-option -gqv "$option" 2>/dev/null || true)
  printf '%s' "${value:-$default}"
}

# Plugin-style tmux overrides keep this local script configurable.
cpu_icon=$(tmux_option '@sys_cpu_icon' '')
gpu_icon=$(tmux_option '@sys_gpu_icon' '󱙺')
ram_icon=$(tmux_option '@sys_ram_icon' '')

timeout_command() {
  require timeout && { timeout 1s "$@"; return; }
  require gtimeout && { gtimeout 1s "$@"; return; }
  return 127
}

# Shared load color scale. CPU/GPU/RAM are pressure metrics, so high is red.
color_for_percentage() {
  local value=${1%.*}

  case $value in
    100|9[5-9]) printf 'brightred' ;;
    8[0-9]|9[0-4]) printf 'red' ;;
    6[5-9]|7[0-9]) printf 'magenta' ;;
    5[0-9]|6[0-4]) printf 'yellow' ;;
    3[5-9]|4[0-9]) printf 'white' ;;
    2[0-9]|3[0-4]) printf 'blue' ;;
    [6-9]|1[0-9]) printf 'green' ;;
    *) printf 'brightgreen' ;;
  esac
}

cpu_percentage() {
  local cores=1 total

  require sysctl && cores=$(sysctl -n hw.logicalcpu 2>/dev/null || printf '1')
  ! require sysctl && require nproc && cores=$(nproc 2>/dev/null || printf '1')
  [[ $cores =~ ^[0-9]+$ && $cores -gt 0 ]] || cores=1

  total=$(ps -A -o %cpu= 2>/dev/null | awk '{sum += $1} END {printf "%.0f", sum}')
  awk -v total="${total:-0}" -v cores="$cores" 'BEGIN {
    value = total / cores
    if (value > 100) value = 100
    printf "%.0f", value
  }'
}

# Apple Silicon exposes cumulative GPU busy time. Cache the previous sample and
# convert the delta into a percentage; first sample prints 0 rather than hiding.
apple_gpu_percentage() {
  local cache now total prev_now prev_total
  cache="${TMPDIR:-/tmp}/tmux-sys-gpu-${USER:-user}.cache"

  read -r now total < <(ioreg -r -c AGXAccelerator -d 2 -l 2>/dev/null \
    | perl -MTime::HiRes=time -ne '
        BEGIN { $timestamp = time() }
        $total += $1 while /"accumulatedGPUTime"=([0-9]+)/g;
        END { printf "%.0f %s\n", $timestamp * 1000000000, $total || 0 }
      ')

  [[ ${now:-} =~ ^[0-9]+$ && ${total:-} =~ ^[0-9]+$ ]] || return 0

  [[ -r $cache ]] && read -r prev_now prev_total <"$cache" || true
  printf '%s %s\n' "$now" "$total" >"$cache"

  [[ ${prev_now:-} =~ ^[0-9]+$ && ${prev_total:-} =~ ^[0-9]+$ ]] || {
    printf '0'
    return 0
  }

  awk -v now="$now" -v total="$total" -v prev_now="$prev_now" -v prev_total="$prev_total" 'BEGIN {
    elapsed = now - prev_now
    used = total - prev_total
    if (elapsed <= 0 || used < 0) {
      print 0
      exit
    }
    value = used * 100 / elapsed
    if (value > 100) value = 100
    printf "%.0f", value
  }'
}

gpu_percentage() {
  local value

  # Prefer dedicated vendor tools. If none are present or readable, emit nothing
  # so desktop/VM/headless machines do not show an empty GPU segment.

  require nvidia-smi && {
    value=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null \
      | awk 'NF { sum += $1; count++ } END { if (count > 0) printf "%.0f", sum / count }')
    [[ -n ${value:-} ]] && printf '%s' "$value"
    return 0
  }

  require intel_gpu_top && {
    value=$(timeout_command intel_gpu_top -J -s 250 2>/dev/null \
      | awk -F '[:,]' '/"Render\/3D\/0"/ { getline; gsub(/[^0-9.]/, "", $2); if ($2 != "") { printf "%.0f", $2; exit } }' || true)
    [[ -n ${value:-} ]] && printf '%s' "$value"
    return 0
  }

  require radeontop && {
    value=$(timeout_command radeontop -d - -l 1 2>/dev/null \
      | awk -F '[,%]' '/gpu/ { for (i = 1; i <= NF; i++) if ($i ~ /gpu/) { gsub(/[^0-9.]/, "", $(i + 1)); printf "%.0f", $(i + 1); exit } }' || true)
    [[ -n ${value:-} ]] && printf '%s' "$value"
    return 0
  }

  [[ $(uname -s) == Darwin ]] && require ioreg && require perl && {
    value=$(apple_gpu_percentage)
    [[ -n ${value:-} ]] && printf '%s' "$value"
  }
}

# Darwin uses vm_stat; Linux uses MemAvailable from /proc/meminfo.
ram_percentage() {
  case $(uname -s) in
    Darwin)
      require vm_stat && {
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
        return 0
      }
      ;;
  esac

  [[ -r /proc/meminfo ]] && {
    awk '
      /MemTotal:/ { total = $2 }
      /MemAvailable:/ { available = $2 }
      END {
        if (total <= 0) total = 1
        printf "%.0f", (total - available) * 100 / total
      }' /proc/meminfo
    return 0
  }

  printf '0'
}

# Battery is auto-hidden when the platform has no battery concept.
battery_metrics() {
  local percentage status='' icon color bat

  if require pmset; then
    percentage=$(pmset -g batt 2>/dev/null | awk '/[0-9]+%/ { match($0, /[0-9]+%/); print substr($0, RSTART, RLENGTH - 1); exit }')
    [[ -n ${percentage:-} ]] || return 0
  elif compgen -G '/sys/class/power_supply/BAT*' &>/dev/null; then
    bat=$(compgen -G '/sys/class/power_supply/BAT*' | head -n 1)
    percentage=$(<"$bat/capacity")
    status=$(<"$bat/status")
  else
    return 0
  fi

  case $percentage in
    ''|*[!0-9]*) return 0 ;;
  esac

  # Battery is a capacity metric, so the color scale is inverted: high is green.
  case $percentage in
    100|9[5-9]) icon='󰂂'; color='brightgreen' ;;
    8[0-9]|9[0-4]) icon='󰂀'; color='green' ;;
    6[5-9]|7[0-9]) icon='󰁿'; color='blue' ;;
    5[0-9]|6[0-4]) icon='󰁿'; color='white' ;;
    3[5-9]|4[0-9]) icon='󰁽'; color='yellow' ;;
    2[0-9]|3[0-4]) icon='󰁼'; color='magenta' ;;
    [6-9]|1[0-9]) icon='󰁺'; color='red' ;;
    *) icon='󰂎'; color='brightred' ;;
  esac

  [[ $status == Charging ]] && icon='󰂄'
  printf '#[fg=%s,bg=default]%s %d%%' "$color" "$icon" "$percentage"
}

metric_segment() {
  local icon=$1 value=$2 color
  color=$(color_for_percentage "$value")
  printf '#[fg=%s,bg=default]%s %d%%' "$color" "$icon" "$value"
}

print_segments() {
  local separator=' #[fg=brightblack,bg=default]· '
  local first=1 segment

  for segment in "$@"; do
    [[ -n $segment ]] || continue
    if (( first )); then
      first=0
    else
      printf '%s' "$separator"
    fi
    printf '%s' "$segment"
  done
}

# Emit a single tmux status command to avoid staggered redraws/flicker.
cpu=$(cpu_percentage)
gpu=$(gpu_percentage)
ram=$(ram_percentage)

segments=("$(metric_segment "$cpu_icon" "$cpu")")
[[ -n ${gpu:-} ]] && segments+=("$(metric_segment "$gpu_icon" "$gpu")")
segments+=("$(metric_segment "$ram_icon" "$ram")")
segments+=("$(battery_metrics)")
print_segments "${segments[@]}"
