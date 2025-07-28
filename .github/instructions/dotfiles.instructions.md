# Copilot Instructions for `dotfiles`

This repository manages personal and portable developer environment configuration ("dotfiles") for rapid setup and reproducibility across machines and cloud-init automation. The primary automation entrypoint is `install.sh`.

## Key Concepts & Structure

- **Single-Script Automation**: `install.sh` is the canonical installer. It is designed to be:
  - **Non-interactive/headless**: All steps run without prompts, suitable for CI/CD and cloud-init.
  - **Verbose and Log-Friendly**: All errors and progress are echoed to stdout for log inspection.
  - **Idempotent**: Safe to re-run; checks for existence before overwriting or cloning.
- **Environment Bootstrapping**: The script sets up `$HOME`, `$XDG_CACHE_HOME`, and ensures `$HOME/.local/bin` is in the shell `$PATH` for both bash and zsh, even in cloud-init or minimal environments.
- **Dotfiles Managed**: Includes `.vimrc`, `.tmux.conf`, `.p10k.zsh`, `.digrc`, `.opencommit`, `.act`, and VSCode settings. All are copied to `$HOME`.
- **Plugin/Theme Management**: Installs and updates Vim, tmux, and Zsh plugins and themes using git, with error output visible in logs.
- **Shell Prompt**: Installs Oh My Posh and configures it for both bash and zsh, including theme and font setup.
- **Cloud/DevOps Ready**: Handles Azure CLI, PowerShell profiles, and Conda initialization if present.

## Project-Specific Patterns

- **Error Handling**: All critical commands redirect stderr to stdout (`2>&1`) so errors are visible in logs. Non-critical failures are logged but do not halt the script.
- **Idempotency**: All install steps check for existing files/directories before creating or cloning. Updates use `git pull --quiet 2>&1`.
- **PATH Management**: The script appends `$HOME/.local/bin` to both `.zshrc` and `.bashrc` if not already present, using a robust check.
- **Font Installation**: Oh My Posh font install errors are non-fatal and logged.
- **Platform Awareness**: Linux-specific tools (e.g., `lsd`) are only installed on Linux.
- **PowerShell Profile**: Installs to the correct config directory based on environment (Azure or standard PowerShell).

## Developer Workflows

- **To install or update all dotfiles and tools:**
  ```sh
  bash install.sh
  ```
- **To debug in cloud-init or CI/CD:**
  - Inspect stdout/stderr logs for any `[dotfiles install.sh]` or error messages.
  - All errors are surfaced; no silent failures.
- **To add new tools/configs:**
  - Add copy/install logic to `install.sh` following the existing pattern: check for existence, log progress, redirect errors.

## Key Files

- `install.sh`: Main automation script. Read top-to-bottom for full flow.
- `.vimrc`, `.tmux.conf`, `.p10k.zsh`, etc.: User config files copied by the script.
- `README.md`: Reference links for dev environment best practices.

## Example Patterns

- **Idempotent copy:**
  ```sh
  cp .vimrc ~/
  ```
- **Plugin update with error logging:**
  ```sh
  cd ~/.vim/pack/plugin/start/vim-airline
  git pull --quiet 2>&1
  ```
- **PATH update in shellrc:**
  ```sh
  if ! grep -q "export PATH=\$PATH:$localbin" "$shellrc"; then
    echo "export PATH=\$PATH:$localbin" >> "$shellrc"
  fi
  ```

## Integration Points

- **Azure CLI**: If present, configures auto-upgrade and completion.
- **Conda**: If present, initializes for all shells.
- **PowerShell**: Installs profile for both Azure and standard environments.

---

For any new automation, follow the patterns in `install.sh` for idempotency, error visibility, and log-friendly output. When in doubt, prefer explicit logging and checks for existence.
