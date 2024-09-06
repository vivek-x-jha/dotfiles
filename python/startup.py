#!/usr/bin/env python3

# XDG Compliant History File: https://gist.github.com/viliampucik/8713b09ff7e4d984b29bfcd7804dc1f4

try:
    import atexit
    import os
    import readline
    import sys
    from pathlib import Path
except ImportError as e:
    print(f"Couldn't load module. {e}")
    sys.exit(1)

# Tab Completion
try:
    readline.parse_and_bind("tab: complete")
except ImportError:
    pass

# Destroy default history file writing hook (and also tab completion, which is why we manually added it)
if hasattr(sys, '__interactivehook__'):
    del sys.__interactivehook__

histfile = Path(os.getenv("XDG_CACHE_HOME", Path.home() / ".cache")) / "python/.python_history"
try:
    histfile.touch(exist_ok=True)
except FileNotFoundError: # Check if parent directory exists
    histfile.parent.mkdir(parents=True, exist_ok=True)

readline.read_history_file(histfile)
readline.set_history_length(10000)
atexit.register(readline.write_history_file, histfile)
