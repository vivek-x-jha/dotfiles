# shellcheck shell=bash disable=SC1091

if command -v rustc >/dev/null 2>&1; then
	source "$(rustc --print sysroot)"/etc/bash_completion.d/cargo
fi
