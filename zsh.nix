{ ... }:
{
    programs.zsh = {
        enable = true;
        completionInit = ''
            #option
            setopt autocd              # change directory just by typing its name
            #setopt correct            # auto correct mistakes
            setopt interactivecomments # allow comments in interactive mode
            setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
            setopt nonomatch           # hide error message if there is no match for the pattern
            setopt notify              # report the status of background jobs immediately
            setopt numericglobsort     # sort filenames numerically when it makes sense
            setopt promptsubst         # enable command substitution in prompt

            WORDCHARS='_-' # Don't consider certain characters part of the word

            # hide EOL sign ('%')
            PROMPT_EOL_MARK=""

            # configure key keybindings
            bindkey -e                                        # emacs key bindings
            bindkey ' ' magic-space                           # do history expansion on space
            bindkey '^U' backward-kill-line                   # ctrl + U
            bindkey '^[[3;5~' kill-word                       # ctrl + Supr
            bindkey '^[[3~' delete-char                       # delete
            bindkey '^[[1;5C' forward-word                    # ctrl + ->
            bindkey '^[[1;5D' backward-word                   # ctrl + <-
            bindkey '^[[5~' beginning-of-buffer-or-history    # page up
            bindkey '^[[6~' end-of-buffer-or-history          # page down
            bindkey '^[[H' beginning-of-line                  # home
            bindkey '^[[F' end-of-line                        # end
            bindkey '^[[Z' undo                               # shift + tab undo last action

            # enable completion features
            autoload -Uz compinit
            compinit -d ~/.cache/zcompdump
            zstyle ':completion:*:*:*:*:*' menu select
            zstyle ':completion:*' auto-description 'specify: %d'
            zstyle ':completion:*' completer _expand _complete
            zstyle ':completion:*' format 'Completing %d'
            zstyle ':completion:*' group-name '''
            zstyle ':completion:*' list-colors '''
            zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
            zstyle ':completion:*' rehash true
            zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
            zstyle ':completion:*' use-compctl false
            zstyle ':completion:*' verbose true
            zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

            # configure `time` format
            TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'


            #source $HOME/.zconfig/main.zsh
        '';
        syntaxHighlighting.enable = true;
        history = {
            size = 50000;              # HISTSIZE - entries kept in memory
            save = 50000;              # SAVEHIST - entries saved to file
            path = "~/.zsh_history";  # HISTFILE location
            ignoreDups = true;         # setopt HIST_IGNORE_DUPS
            ignoreAllDups = true;      # setopt HIST_IGNORE_ALL_DUPS
            ignoreSpace = true;        # setopt HIST_IGNORE_SPACE (don't save cmds starting with space)
            expireDuplicatesFirst = true;  # setopt HIST_EXPIRE_DUPS_FIRST
            share = true;              # setopt SHARE_HISTORY (share across sessions in real-time)
            extended = true;           # setopt EXTENDED_HISTORY (save timestamps)
            append = true;             # setopt APPEND_HISTORY
            findNoDups = true;         # setopt HIST_FIND_NO_DUPS
        };
    };
}