# Ponytail

Shared configuration for [Ponytail](https://github.com/DietrichGebert/ponytail), the
minimal-implementation ruleset used by the installed coding-agent harnesses.

Bootstrap seeds `config.json` to `$XDG_CONFIG_HOME/ponytail/config.json` only when the
runtime file is absent. The runtime copy stays user-owned so `/ponytail default <mode>`
can change it without dirtying this checkout.

Claude's marketplace, enabled-plugin declaration, and status line are tracked in
`ai/claude-code/settings.json`. Downloaded plugin/package files remain harness-owned
runtime state. Use these commands to install or repair each harness:

```sh
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
codex plugin marketplace add DietrichGebert/ponytail --ref main
codex plugin add ponytail@ponytail
pi install git:github.com/DietrichGebert/ponytail
hermes plugins install DietrichGebert/ponytail --enable
```

Start a new harness session after installation. Codex also requires reviewing and
trusting Ponytail's two lifecycle hooks through `/hooks`. Use `/ponytail status` where
supported, and `/ponytail default lite|full|ultra|off` to change the default.
