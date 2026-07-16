#!/bin/sh
set -eu

: "${HOME:?HOME must be set}"

xdg_config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
xdg_cache_home=${XDG_CACHE_HOME:-"$HOME/.cache"}
xdg_data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
xdg_state_home=${XDG_STATE_HOME:-"$HOME/.local/state"}
codex_home=${CODEX_HOME:-"$xdg_state_home/codex"}
hermes_home=${HERMES_HOME:-"$xdg_data_home/hermes"}
nvim_log_file=${NVIM_LOG_FILE:-"$xdg_state_home/nvim/nvim.log"}
pi_agent_dir=${PI_CODING_AGENT_DIR:-"$xdg_state_home/pi/agent"}
vscode_portable=${VSCODE_PORTABLE:-"$xdg_data_home/vscode"}
ollama_host=${OLLAMA_HOST:-"127.0.0.1:11434"}
ollama_flash_attention=${OLLAMA_FLASH_ATTENTION:-1}
ollama_kv_cache_type=${OLLAMA_KV_CACHE_TYPE:-q8_0}

/bin/launchctl setenv XDG_CONFIG_HOME "$xdg_config_home"
/bin/launchctl setenv XDG_CACHE_HOME "$xdg_cache_home"
/bin/launchctl setenv XDG_DATA_HOME "$xdg_data_home"
/bin/launchctl setenv XDG_STATE_HOME "$xdg_state_home"
/bin/launchctl setenv CODEX_HOME "$codex_home"
/bin/launchctl setenv HERMES_HOME "$hermes_home"
/bin/launchctl setenv NVIM_LOG_FILE "$nvim_log_file"
/bin/launchctl setenv PI_CODING_AGENT_DIR "$pi_agent_dir"
/bin/launchctl setenv VSCODE_PORTABLE "$vscode_portable"
/bin/launchctl setenv OLLAMA_HOST "$ollama_host"
/bin/launchctl setenv OLLAMA_FLASH_ATTENTION "$ollama_flash_attention"
/bin/launchctl setenv OLLAMA_KV_CACHE_TYPE "$ollama_kv_cache_type"
