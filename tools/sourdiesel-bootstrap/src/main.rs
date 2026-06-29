use std::env;
use std::io::{self, Write};
use std::path::PathBuf;
use std::process::{Command, Stdio};

const BLACK: &str = "\x1b[38;2;204;204;204m";
const GREEN: &str = "\x1b[38;2;206;255;201m";
const YELLOW: &str = "\x1b[38;2;253;247;205m";
const BLUE: &str = "\x1b[38;2;196;239;250m";
const MAGENTA: &str = "\x1b[38;2;236;206;240m";
const BRIGHTBLACK: &str = "\x1b[38;2;92;97;125m";
const SURFACE: &str = "\x1b[48;2;33;32;48m";
const RESET: &str = "\x1b[0m";

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Status {
    Done,
    Needed,
    Risk,
    Unknown,
}

impl Status {
    fn label(self) -> &'static str {
        match self {
            Status::Done => "done",
            Status::Needed => "needed",
            Status::Risk => "risk",
            Status::Unknown => "unknown",
        }
    }
}

struct Substep {
    code: &'static str,
    label: &'static str,
}

struct Task {
    id: &'static str,
    code: &'static str,
    label: &'static str,
    risk: &'static str,
    summary: &'static str,
    inputs: &'static [&'static str],
    outputs: &'static [&'static str],
    tests: &'static [&'static str],
    substeps: &'static [Substep],
}

fn tasks() -> Vec<Task> {
    vec![
        Task {
            id: "packages",
            code: "1a",
            label: "install package manifests",
            risk: "network",
            summary: "Install missing CLI tools/apps from platform manifests.",
            inputs: &[
                "detected package manager",
                "Brewfile/apt/dnf manifest",
                "configured cask selection",
            ],
            outputs: &[
                "package manager install commands",
                "optional cleanup/upgrade commands",
            ],
            tests: &[
                "package manager executable exists",
                "manifest path is readable",
            ],
            substeps: &[
                Substep {
                    code: "1a.i",
                    label: "detect package manager",
                },
                Substep {
                    code: "1a.ii",
                    label: "read manifest",
                },
                Substep {
                    code: "1a.iii",
                    label: "install missing packages",
                },
            ],
        },
        Task {
            id: "fzf",
            code: "1b",
            label: "install and wire fzf",
            risk: "safe",
            summary: "Ensure fzf binary and shell integration are available.",
            inputs: &["command -v fzf", "cli/fzf/fzf.sh", "shell startup files"],
            outputs: &[
                "fzf install only when missing",
                "shell integration remains sourced",
            ],
            tests: &["fzf --version", "shell-load smoke test"],
            substeps: &[
                Substep {
                    code: "1b.i",
                    label: "check fzf binary",
                },
                Substep {
                    code: "1b.ii",
                    label: "check shell integration",
                },
                Substep {
                    code: "1b.iii",
                    label: "run backend test",
                },
            ],
        },
        Task {
            id: "symlinks",
            code: "2a",
            label: "create XDG symlinks",
            risk: "safe",
            summary: "Create/update home and XDG links back to this checkout.",
            inputs: &[
                "repo source paths",
                "home/XDG target paths",
                "current target if any",
            ],
            outputs: &[
                "new symlink",
                "updated symlink",
                "conflict warning",
                "no-op when already correct",
            ],
            tests: &["expected symlink targets match"],
            substeps: &[
                Substep {
                    code: "2a.i",
                    label: "inspect targets",
                },
                Substep {
                    code: "2a.ii",
                    label: "create missing directories",
                },
                Substep {
                    code: "2a.iii",
                    label: "link dotfiles",
                },
            ],
        },
        Task {
            id: "codex",
            code: "2b",
            label: "configure Codex UI",
            risk: "safe",
            summary: "Apply tracked Codex preferences and SourDiesel theme.",
            inputs: &[
                "ai/codex/config/preferences.toml",
                "ai/codex/scripts/apply_preferences.py",
            ],
            outputs: &[
                "Codex config under XDG config/state",
                "theme preference updates",
            ],
            tests: &["preferences script exits successfully"],
            substeps: &[
                Substep {
                    code: "2b.i",
                    label: "read preferences",
                },
                Substep {
                    code: "2b.ii",
                    label: "apply preferences",
                },
                Substep {
                    code: "2b.iii",
                    label: "verify config",
                },
            ],
        },
        Task {
            id: "git",
            code: "3a",
            label: "configure git and GitHub CLI",
            risk: "secret",
            summary: "Configure git identity, signing, and optional GitHub auth.",
            inputs: &[
                "existing git config",
                "BOOTSTRAP_GIT_*",
                "optional op/gh auth state",
            ],
            outputs: &[
                "git config updates",
                "gh auth/wrapping when explicitly enabled",
            ],
            tests: &[
                "git config user.name",
                "git config user.email",
                "gh auth status when enabled",
            ],
            substeps: &[
                Substep {
                    code: "3a.i",
                    label: "read identity",
                },
                Substep {
                    code: "3a.ii",
                    label: "configure git",
                },
                Substep {
                    code: "3a.iii",
                    label: "verify auth tools",
                },
            ],
        },
        Task {
            id: "shell-plugins",
            code: "3b",
            label: "install shell plugin managers",
            risk: "network",
            summary: "Install zap and ble.sh only when needed.",
            inputs: &["$XDG_DATA_HOME/zap/zap.zsh", "ble.sh checkout/install path"],
            outputs: &["zap install", "ble.sh make install"],
            tests: &["zap.zsh exists", "ble.sh files exist"],
            substeps: &[
                Substep {
                    code: "3b.i",
                    label: "check zap",
                },
                Substep {
                    code: "3b.ii",
                    label: "install zap",
                },
                Substep {
                    code: "3b.iii",
                    label: "install ble.sh",
                },
            ],
        },
        Task {
            id: "bat",
            code: "4a",
            label: "build bat theme cache",
            risk: "safe",
            summary: "Rebuild bat cache for tracked themes.",
            inputs: &["bat binary", "bat themes directory"],
            outputs: &["bat cache --build"],
            tests: &["bat cache command exits successfully"],
            substeps: &[
                Substep {
                    code: "4a.i",
                    label: "check bat",
                },
                Substep {
                    code: "4a.ii",
                    label: "build cache",
                },
            ],
        },
        Task {
            id: "sudo",
            code: "5a",
            label: "configure Touch ID sudo",
            risk: "privileged",
            summary: "Optional privileged macOS sudo authentication setup.",
            inputs: &["macOS platform", "sudo authorization", "pam config state"],
            outputs: &["pam sudo_local template/config"],
            tests: &["configured file contains pam_tid.so"],
            substeps: &[
                Substep {
                    code: "5a.i",
                    label: "confirm privilege",
                },
                Substep {
                    code: "5a.ii",
                    label: "write sudo auth config",
                },
                Substep {
                    code: "5a.iii",
                    label: "verify pam entry",
                },
            ],
        },
        Task {
            id: "ide",
            code: "6a",
            label: "setup IDE tools",
            risk: "network",
            summary: "Install editor support tools and Neovim helpers.",
            inputs: &["bob/nvim availability", "language tool manifests"],
            outputs: &["IDE/editor tool installs", "Neovim helper setup"],
            tests: &["tool binaries are available"],
            substeps: &[
                Substep {
                    code: "6a.i",
                    label: "check editor tools",
                },
                Substep {
                    code: "6a.ii",
                    label: "install missing tools",
                },
                Substep {
                    code: "6a.iii",
                    label: "verify backend",
                },
            ],
        },
    ]
}

fn main() -> io::Result<()> {
    let mut root = env::var_os("SOURDIESEL_BOOTSTRAP_ROOT")
        .map(PathBuf::from)
        .unwrap_or(env::current_dir()?);
    let mut dry_run = false;
    let mut args = env::args().skip(1);
    while let Some(arg) = args.next() {
        match arg.as_str() {
            "--root" => {
                if let Some(value) = args.next() {
                    root = PathBuf::from(value);
                }
            }
            "--dry-run" => dry_run = true,
            _ => {}
        }
    }

    let mut app = App {
        root,
        dry_run,
        selected: 0,
        log: String::new(),
    };
    app.run()
}

struct App {
    root: PathBuf,
    dry_run: bool,
    selected: usize,
    log: String,
}

impl App {
    fn run(&mut self) -> io::Result<()> {
        let tasks = tasks();
        loop {
            self.render(&tasks)?;
            print!("\n{BLUE}command{RESET} [j/k move, enter apply, r retest, d details, q quit]: ");
            io::stdout().flush()?;
            let mut input = String::new();
            io::stdin().read_line(&mut input)?;
            match input.trim() {
                "q" => break,
                "j" | "down" => self.selected = (self.selected + 1).min(tasks.len() - 1),
                "k" | "up" => self.selected = self.selected.saturating_sub(1),
                "" | "enter" => self.apply(&tasks[self.selected])?,
                "r" => self.retest(&tasks[self.selected]),
                "d" => self.details(&tasks[self.selected]),
                _ => self.log = "unknown command".to_string(),
            }
        }
        Ok(())
    }

    fn render(&self, tasks: &[Task]) -> io::Result<()> {
        print!("\x1b[2J\x1b[H{SURFACE}");
        println!("{MAGENTA}sourdiesel-bootstrap{RESET} {BRIGHTBLACK}orbital installer{RESET}");
        println!("{BRIGHTBLACK}root: {}{RESET}\n", self.root.display());

        let width = 54usize;
        for (idx, task) in tasks.iter().enumerate() {
            let status = self.status(task);
            let active = idx == self.selected;
            let (icon_color, text_color) = row_colors(status, active);
            let icon = if status == Status::Done { "●" } else { "○" };
            let row = format!(
                "{icon_color}{icon}{RESET} {text_color}{}: {}{RESET}",
                task.code, task.label
            );
            println!(
                "{row:<width$} {BRIGHTBLACK}[{} / {}]{RESET}",
                status.label(),
                task.risk
            );
            if active {
                for substep in task.substeps {
                    println!("  {YELLOW}◌ {}: {}{RESET}", substep.code, substep.label);
                }
            }
        }

        let task = &tasks[self.selected];
        println!("\n{BLUE}Install Preview{RESET}");
        println!("{BLACK}{}{RESET}", task.summary);
        print_group("Inputs", task.inputs);
        print_group("Outputs", task.outputs);
        print_group("Backend tests", task.tests);
        println!(
            "\n{BLUE}Last message{RESET}\n{}",
            if self.log.is_empty() {
                "<none>"
            } else {
                &self.log
            }
        );
        Ok(())
    }

    fn apply(&mut self, task: &Task) -> io::Result<()> {
        if matches!(task.risk, "secret" | "privileged")
            && !confirm(&format!("{} is {}; continue", task.id, task.risk))?
        {
            self.log = format!("skipped {}", task.id);
            return Ok(());
        }

        let mut command = Command::new(self.root.join("bootstrap.sh"));
        command.arg("--partial").arg("--only").arg(task.id);
        if self.dry_run {
            command.arg("--dry-run");
        }
        command.current_dir(&self.root);
        self.log = run_command(command);
        Ok(())
    }

    fn retest(&mut self, task: &Task) {
        self.log = format!("{} status: {}", task.id, self.status(task).label());
    }

    fn details(&mut self, task: &Task) {
        self.log = format!(
            "{}\ninputs: {}\noutputs: {}\ntests: {}",
            task.summary,
            task.inputs.join(", "),
            task.outputs.join(", "),
            task.tests.join(", ")
        );
    }

    fn status(&self, task: &Task) -> Status {
        match task.id {
            "fzf" => cmd_ok("fzf")
                .then_some(Status::Done)
                .unwrap_or(Status::Needed),
            "git" => {
                let name = command_success("git", &["config", "--global", "user.name"]);
                let email = command_success("git", &["config", "--global", "user.email"]);
                if name && email {
                    Status::Done
                } else {
                    Status::Needed
                }
            }
            "bat" => cmd_ok("bat")
                .then_some(Status::Done)
                .unwrap_or(Status::Needed),
            "packages" => {
                if cmd_ok("brew") || cmd_ok("apt-get") || cmd_ok("dnf") || cmd_ok("dnf5") {
                    Status::Done
                } else {
                    Status::Needed
                }
            }
            "symlinks" => symlink_ok(".zshenv", ".config/shells/env")
                .then_some(Status::Done)
                .unwrap_or(Status::Needed),
            "codex" => self
                .root
                .join("ai/codex/config/preferences.toml")
                .is_file()
                .then_some(Status::Done)
                .unwrap_or(Status::Needed),
            "sudo" => Status::Risk,
            _ => Status::Unknown,
        }
    }
}

fn row_colors(status: Status, active: bool) -> (&'static str, &'static str) {
    if active {
        (YELLOW, YELLOW)
    } else if status == Status::Done {
        (GREEN, BLACK)
    } else {
        (BRIGHTBLACK, BRIGHTBLACK)
    }
}

fn print_group(label: &str, rows: &[&str]) {
    println!("\n{MAGENTA}{label}{RESET}");
    for row in rows {
        println!("  {BRIGHTBLACK}•{RESET} {BLACK}{row}{RESET}");
    }
}

fn confirm(prompt: &str) -> io::Result<bool> {
    print!("{YELLOW}{prompt}? [y/N]: {RESET}");
    io::stdout().flush()?;
    let mut input = String::new();
    io::stdin().read_line(&mut input)?;
    Ok(matches!(input.trim(), "y" | "Y" | "yes" | "YES"))
}

fn cmd_ok(bin: &str) -> bool {
    Command::new("sh")
        .arg("-c")
        .arg(format!("command -v {bin} >/dev/null 2>&1"))
        .status()
        .map(|status| status.success())
        .unwrap_or(false)
}

fn command_success(bin: &str, args: &[&str]) -> bool {
    Command::new(bin)
        .args(args)
        .output()
        .map(|output| output.status.success() && !output.stdout.is_empty())
        .unwrap_or(false)
}

#[cfg(unix)]
fn symlink_ok(link_name: &str, expected: &str) -> bool {
    let link = env::var_os("HOME")
        .map(PathBuf::from)
        .unwrap_or_default()
        .join(link_name);
    let Ok(meta) = std::fs::symlink_metadata(&link) else {
        return false;
    };
    if !meta.file_type().is_symlink() {
        return false;
    }
    let Ok(actual) = std::fs::read_link(&link) else {
        return false;
    };
    actual == PathBuf::from(expected)
}

#[cfg(not(unix))]
fn symlink_ok(_link_name: &str, _expected: &str) -> bool {
    false
}

fn run_command(mut command: Command) -> String {
    println!("{BLUE}Launching bootstrap backend with inherited terminal I/O...{RESET}");
    println!("{BRIGHTBLACK}Return to sourdiesel-bootstrap when the command exits.{RESET}\n");

    command
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit());

    match command.status() {
        Ok(status) => {
            print!("\n{BLUE}backend exited with {status}. Press Enter to return to the installer...{RESET}");
            let _ = io::stdout().flush();
            let mut input = String::new();
            let _ = io::stdin().read_line(&mut input);
            format!("backend exited with {status}")
        }
        Err(err) => format!("failed to run bootstrap backend: {err}"),
    }
}
