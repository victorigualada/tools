### List - single column

# One line. With types.
# Note that just `1` is already reserved in ZSH for navigate back a directory.
alias l1='ls -1 -F'

# Wrapping names.
alias l='ls -C -F'

# Show hidden.
alias la='ls -A'
# With types.
alias la1='ls -A -F -1'

### List - long (aka multi-column view)

alias ll='ls -l -h'
alias lal='ls -l -h -A -F'

# Newest first and show ISO date and time.
alias lt='ls -t --full-time'

# Largest files first.
alias lS='ls -l -F -S'

### List - other

# If you need to use original ls, run
#   /bin/ls or /usr/bin/ls
# Or command e.g.
#   command ls
#   command ls -l

# LINUX
#
# --color=format
#   The flag fails on macOS.
#
# --group-directories-first
#     Put directories first (for both short and long listing).
#     One comment online said for macOS to use coreutils (brew install coreutils) but this did not help me.
#
# -G --no-group
#     Hide group when doing long listing. (Fewer columns)
#
# MACOS
#
# -G
#     Enable color output
#     (Note this is different from Linux's '-G')
#
if [[ "$IS_LINUX" == 'true' ]]; then
  LS_FLAGS='--group-directories-first --no-group --color=auto'
else
  LS_FLAGS='-G'
fi

# Sort underscores first before lowercase files and folders, but still after uppercase.
# Untested for mac but on Linux en_US or C both work.
LS_ENV='LC_COLLATE=en_US '

# This alias should defined *last* in order to keep color in all the aliases above active.
alias ls="$LS_ENV ls $LS_FLAGS"
unset LS_ENV LS_FLAGS

### Config checks

# Display PATH over multiple lines.
alias split_path='echo "$PATH" | sed "s/:/\n/g"'

# List bin executables available, by directory.
alias bins='ls -1 -R ~/bin'

### Other

# Zip. Args: TARBALL INFILES
alias tarz='tar czvf'
# Unzip. Args: TARBALL
alias taru='tar xzvf'

#   -i     prompt before every removal
#   -I     prompt once before removing more than three files, or when removing recursively; less  intrusive  than  -i,
#           while still giving protection against most mistakes (Linux only)
# Override with rm -f
alias rm='rm -i'

# For managing jobs sent to background with CTRL+Z and `fg`.
alias j="jobs -l"

alias pserver='python3 -m http.server'
alias pip-user='PIP_REQUIRE_VIRTUALENV=false python3 -m pip'

if [[ "$IS_LINUX" == 'true' ]]; then
  # Skip if root.
  if [ $UID -ne 0 ]; then
    alias reboot='sudo reboot'
    alias upgrade='sudo apt-get update && sudo apt-get upgrade'
    # Note `install` is already a thing so don't use it.
    alias apt-i='sudo apt install'
  fi
fi

# Summarize directory.
#   Breakdown of sorted sizes of files and directories at current level (depth of zero combined with using *).
#   Sorted by human-readable sizes and reversed.
#   This is expensive at ~.
#
# Friendly summary of dirs.
# Ignores .git and other hidden folders by using *.
alias usage='du -h -s -c * | sort -h -r'
# Similar to above but excludes files and includes hidden directories.
# This can work without args (same as `.`) or with a path.
alias du1='du -h -d 1'

# Show files and dirs and not just dirs. Similar to find but with sizes. And similar to ls -h but ls
# is not good for parsing.
alias dua='du -h -a'

# Concat lists and pick one.
alias random_alias='{ alias & git alias ;} | shuf -n 1'

### Git
alias g='git'

### Docker
alias dps='docker ps'
alias dstart='docker start'
alias dstop='docker stop'


alias dcps='docker-compose ps'
alias dcstart='docker-compose start'
alias dcstop='docker-compose stop'
alias dcup='docker-compose up'
alias dcdown='docker-compose down'
alias dcrestart='docker-compose restart'
# Usage: dexec COMMAND
alias dexec='docker exec -it /bin/sh'
# Update images
alias dpull='docker pull'

### Searching

# Search using PATTERN.
alias hg='history | grep'
alias ag='alias | grep'

# Recent history.
alias hi='history | tail -n20'

# Find by given NAME.
alias fn='find . -name'
alias fnd='find . -type d -name'
alias fnf='find .  -type f -name'

# Enable color for grep as default has nothing. Works on macOS and Linux. Copied from Ubuntu.
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# Bat
alias cat='batcat --theme=ansi-dark --tabs=2 --style="numbers,changes,header"'

# LSOF
alias ports='sudo lsof -i -P -n | grep LISTEN'
alias port='sudo lsof -i -P -n | grep LISTEN | grep '
