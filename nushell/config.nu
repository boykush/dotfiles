alias vi = nvim
alias cat = bat

use ~/.cache/starship.nu
source ~/.cache/zoxide.nu

def fbr [] {
  let branches = (
    git branch --all
    | grep -v HEAD
  )

  let branch = (
    $branches
    | fzf
    | str replace -r '\s*' ''
    | str replace -r 'remotes/[^/]*/' ''
  )

  git checkout $branch
}
