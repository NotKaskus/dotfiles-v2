# Basic shortcuts
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias glp="git log --pretty=format:'%h - %s (%an, %ar)'"

# Commit and push
alias gcp='git commit && git push'

# Staging and committing
alias gac='git add . && git commit'
alias gacp='git add . && git commit && git push'

# Branch operations
alias gcb='git checkout -b'
alias gbd='git branch -d'
alias gbD='git branch -D' # force delete branch
alias gbm='git branch -m'

# Fetch and prune
alias gfp='git fetch --prune'

# Git stash operations
alias gst='git stash'
alias gstp='git stash pop'
alias gsts='git stash show -p'

# Merge and rebase
alias gm='git merge'
alias grb='git rebase'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

# Viewing changes
alias gsh='git show'
alias glg='git log --graph --oneline --decorate --all'

# More detailed status
alias gss='git status -sb'

# Utility
alias gcl='git clean -fd'
alias gt='git tag'
alias gtl='git tag -l'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gcpa='git cherry-pick --abort'
alias gcpaa='git cherry-pick --continue'

# Git remote operations
alias gr="git remote"
alias grs="git remote show" # Show current remote origin
alias grl="git remote -v" # List all currently configured remotes
alias grr="git remote rm origin" # Remove current origin
alias gra="git remote add" # Add new remote origin
alias grurl="git remote set-url origin" # Sets URL of existing origin

# Git LFS
alias glfsi='git lfs install'
alias glfst='git lfs track'
alias glfsls='git lfs ls-files'
alias glfsmi='git lfs migrate import --include='

# Push LFS changes to current branch
function gplfs() {
  git lfs push origin "$(git_current_branch)" --all
}

# Sync fork against upstream repo
function gsync {
  # If no upstream origin provided, prompt user for it
  if ! git remote -v | grep -q 'upstream'; then
    echo 'Enter the upstream git url: ';
    read url;
    git remote add upstream "$url"
  fi
  git remote -v
  git fetch upstream
  git pull upstream master
  git checkout master
  git rebase upstream/master
}

# Make git commit with -m
function gcommit {
  commit_msg=$@
  if [ $# -eq 0 ]; then
    echo 'Enter a commit message';
    read commit_msg;
  fi
  git commit -m "$commit_msg"
}

alias gcm="gcommit"

# Fetch, rebase and push updates to current branch 
# Optionally specify target, defaults to 'master'
function gfetchrebase {
  if ! [ -z "$1" ]; then
    branch=$1
  else
    branch='master'
  fi
  git fetch upstream
  git rebase upstream/$branch
  git push
}

alias gfrb="gfetchrebase"

# Integrates with gitignore.io to auto-populate .gitignore file
function gignore() {
  curl -fLw '\n' https://www.gitignore.io/api/"${(j:,:)@}"
}
_gitignoreio_get_command_list() {
  curl -sfL https://www.gitignore.io/api/list | tr "," "\n"
}
_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}
# Downloads specific git ignore template to .gitignore
gignore-apply () {
  if [ -n $search_term ]; then
    gignore $1 >> .gitignore
  else
    echo "Expected a template to be specified. Run:"
    echo "  $ gignore list to view all options"
    echo "  $ gignore [template] to preview"
  fi
}

# Helper function to return URL of current repo (based on origin)
get-repo-url() {
  git_base_url='https://github.com'
  # Get origin from git repo + remove .git
  git_url=${$(git config --get remote.origin.url)%.git}
  # Process URL, and append branch / working origin 
  if [[ $git_url =~ ^git@ ]]; then
    branch=${1:-"$(git symbolic-ref --short HEAD)"}
    branchExists="$(git ls-remote --heads $git_url $branch | wc -l)"
    github="$(echo $git_url | sed 's/git@//')" # Remove git@ from the start
    github="$(echo $github | sed 's/\:/\//')" # Replace : with /
    if [[ $branchExists == "       1" ]]; then
        git_url="http://$github/tree/$branch"
    else
        git_url="http://$github"
    fi
  elif [[ $git_url =~ ^https?:// ]]; then
    branch=${1:-"$(git symbolic-ref --short HEAD)"}
    branchExists="$(git ls-remote --heads $git_url $branch | wc -l)"
    if [[ $branchExists == "       1" ]]; then
        git_url="$git_url/tree/$branch"
    else
        git_url="$git_url"
    fi
  fi
  # Return URL
  echo $git_url
}

# Helper function that gets supported open method for system
launch-url() {
  if hash open 2> /dev/null; then
    open_command=open
  elif hash xdg-open 2> /dev/null; then
    open_command=xdg-open
  elif hash lynx 2> /dev/null; then
    open_command=lynx
  else
    echo -e "\033[0;33mUnable to launch browser, open manually instead"
    echo -e "\033[1;96m🌐 URL: \033[0;96m\e[4m$1\e[0m"
    return;
  fi
  echo $open_command
}

# Opens the current repo + branch in GitHub
open-github() {
  git_base_url='https://github.com' # Modify this if using GH enterprise
  if [[ ! -z $1 && ! -z $2  ]]; then
    # User specified a repo
    git_url=$git_base_url/$1/$2
  elif git rev-parse --git-dir > /dev/null 2>&1; then
    # Get URL from current repo's origin
    git_url=$(get-repo-url)
  else
    # Not in repo, and nothing specified, open homepage
    git_url=$git_base_url
  fi
  # Determine which open commands supported
  open_command=$(launch-url $git_url)
  # Print messages
  echo -e "\033[1;96m🐙 Opening in browser: \033[0;96m\e[4m$git_url\e[0m"
  # And launch!
  $open_command $git_url
}

alias gho='open-github'

# Opens pull request tab for the current GH repo
open-github-pulls() {
  # Get Repo URL
  if git rev-parse --git-dir > /dev/null 2>&1; then
    git_url=$(get-repo-url)
  else
    git_url='https://github.com'
  fi
  git_url="$git_url/pulls"
  # Get open command
  open_command=$(launch-url $git_url)
  # Print message, and launch!
  echo -e "\033[1;96m🐙 Opening in browser: \033[0;96m\e[4m$git_url\e[0m"
  $open_command $git_url
}

alias ghp='open-github-pulls'