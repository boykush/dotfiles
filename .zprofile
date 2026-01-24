# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise - runtime version manager
# Placed here so non-interactive shells (e.g., Claude Code) can access mise-managed tools
eval "$(mise activate zsh)"
