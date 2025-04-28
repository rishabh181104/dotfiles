if status is-interactive
	fastfetch
end

starship init fish | source

# Set environment variables
set -Ux OZONE_PLATFORM wayland
set -Ux __GLX_VENDOR_LIBRARY_NAME nvidia
set -Ux MOZ_ENABLE_WAYLAND 1
set -gx EDITOR nvim
set -gx TERMINAL alacritty
set -gx BROWSER firefox
set -gx FILE ~/.config/fish/config.fish
set -gx STARSHIP_CONFIG ~/.config/starship.toml
set -gx VISUAL nvim
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH /usr/local/bin $PATH
set -gx PATH /usr/bin $PATH
set -gx PATH $HOME/.cargo/env.fish $PATH

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -a'
alias l='ls -CF'
alias vim='nvim'
alias clr='clear'
alias run='/usr/bin/python3'
alias grep='grep --color=auto'
alias brght='brightnessctl set'

alias convert='ffmpeg -i $argv[1] -filter_complex "[0:v] fps=10,scale=320:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" $argv[2]'
alias upgrade='sudo zypper ref && sudo zypper dup -y'
alias update='sudo zypper ref'
alias recom='sudo zypper install-new-recommends'
alias remove='sudo zypper remove'
alias search='zypper se'
alias install='sudo zypper in'
alias remove-unwanted='sudo zypper rm $(zypper packages --unneeded)'
alias remove-cache='sudo zypper clean --all'
alias zlock='sudo zypper addlock'

alias c='clear'
alias n='nvim'
alias sn='sudo nvim'
alias nv='nvim'
alias nvi='nvim'
alias v='nvim'
alias duf='duf -hide special'
alias mkdir='mkdir -p'
alias zen='~/zen/./zen'
alias fetch='fastfetch'
alias restart-dm='sudo systemctl restart display-manager'
alias smv='sudo mv'
alias scp='sudo cp'

alias anime='~/dotfiles/./ani-cli'

alias web='cd /var/www/html'
alias ebrc='edit ~/.bashrc'
alias hlp='less ~/.bashrc_help'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose '
alias la='ls -Alh'
alias ls='ls -aFh --color=always'
alias lx='ls -lXBh'
alias lk='ls -lSrh'
alias lc='ls -ltcrh'
alias lu='ls -lturh'
alias lr='ls -lRh'
alias lt='ls -ltrh'
alias lm='ls -alh |more'
alias lw='ls -xAh'
alias ll='ls -Fls'
alias labc='ls -lap'
alias lf="ls -l | egrep -v '^d'"
alias ldir="ls -l | egrep '^d'"
alias lla='ls -Al'
alias las='ls -A'
alias lls='ls -l'
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
alias h="history | grep "
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias f="find . | grep "
alias checkcommand="type -t"
alias openports='netstat -nape --inet'
alias rebootsafe='sudo shutdown -r now'
alias shutdown='sudo shutdown now'
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias sha1='openssl sha1'
alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'
alias kssh="kitty +kitten ssh"

# Functions
function fish_greeting
	echo "THIS IS FISH, BRUV!:)"
end

function mkcd
	mkdir -p $argv[1]; and cd $argv[1]
end

function reload
	exec fish
end

function fish_prompt
	starship prompt
end

function brave-nvidia
	env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia brave-browser --use-gl=desktop
end

# Source other configs if necessary
if test -f ~/.config/fish/local.fish
	source ~/.config/fish/local.fish
end

export WINEESYNC=1
export WINEFSYNC=1


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '~/.opam/opam-init/init.fish' && source '~/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration


# THIS IS FOR THE AUTOMATIC STARTUP OF THE SESSIONS YOU WANT WITH XORG
if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
	exec startx
end


# THIS IS FOR THE AUTOMATIC STARTUP OF THE SESSIONS YOU WANT WITH WAYLAND
# if test -z "$WAYLAND_DISPLAY"; and test (tty) = "/dev/tty1"
# 	exec dbus-run-session sway
# end
