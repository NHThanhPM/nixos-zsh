# Converted from https://github.com/NHThanhPM/.zconfig
#
# Usage: put this file and prompt.zsh in the same directory, then in home.nix:
#   imports = [ ./zsh.nix ];
#
# Requires `config`, `pkgs`, `lib` in scope (standard for home-manager modules).

{ config, pkgs, lib, ... }:

{
  # Ship the Kali-style prompt script verbatim (kept as a plain file, not an
  # inline Nix string, to avoid escaping headaches with zsh's $'...' quoting
  # and ${...} parameter expansion clashing with Nix's own ${...} interpolation)
  home.file.".zconfig/prompt.zsh".source = ./prompt.zsh;

  programs.zsh = {
    enable = true;

    # --- shared/option.zsh ---
    autocd = true; # setopt autocd

    # --- shared/history.zsh ---
    history = {
      path = "${config.home.homeDirectory}/.zsh_history"; # HISTFILE
      size = 1000;                                          # HISTSIZE
      save = 2000;                                          # SAVEHIST
      ignoreDups = true;                                    # hist_ignore_dups
      ignoreSpace = true;                                   # hist_ignore_space
      expireDuplicatesFirst = true;                         # hist_expire_dups_first
      share = false;                                        # share_history was commented out (disabled) upstream
    };

    # --- shared/aliases.zsh + history alias + color.zsh aliases ---
    shellAliases = {
      ll = "ls -l";
      la = "ls -A";
      l = "ls -CF";
      history = "history 0";


      nixos-rebuild-full = "sudo nixos-rebuild switch --flake /etc/nixos/nixos-config#thanh-laptop --impure";
      home-manager-rebuild = "home-manager switch --flake /home/thanh/nixos-home#nixos --impure";

      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip --color=auto";

      ls = if pkgs.stdenv.isDarwin then "ls -G" else "ls --color=auto";
    }
    # --- Darwin/aliases.zsh ---
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      code = "open -a \"Visual Studio Code\"";
      subl = "open -a \"Sublime Text\"";
      atom = "open -a \"Atom\"";
      chrome = "open -a \"Google Chrome\"";
      xcode = "open -a \"Xcode\"";
      finder = "open .";
      preview = "open -a \"Preview\"";
      terminal = "open -a \"Terminal\"";
      iterm = "open -a \"iTerm\"";
    };

    # --- shared/style.zsh: completion system ---
    enableCompletion = true; # replaces manual `autoload -Uz compinit; compinit`

    # --- Linux/auto_suggest.zsh + Darwin/auto_suggest.zsh + shared/auto_suggest.zsh ---
    # native HM option instead of hardcoded /usr/share or /usr/local/share paths
    autosuggestion = {
      enable = true;
      highlight = "fg=244"; # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
    };

    # --- shared/prompt.zsh referenced $SYN_HIGH_PATH manually; native option instead ---
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" ];
      styles = {
        default = "none";
        unknown-token = "underline";
        reserved-word = "fg=cyan,bold";
        suffix-alias = "fg=green,underline";
        global-alias = "fg=green,bold";
        precommand = "fg=green,underline";
        commandseparator = "fg=blue,bold";
        autodirectory = "fg=green,underline";
        path = "bold";
        globbing = "fg=blue,bold";
        history-expansion = "fg=blue,bold";
        command-substitution-delimiter = "fg=magenta,bold";
        process-substitution-delimiter = "fg=magenta,bold";
        single-hyphen-option = "fg=green";
        double-hyphen-option = "fg=green";
        back-quoted-argument-delimiter = "fg=blue,bold";
        single-quoted-argument = "fg=yellow";
        double-quoted-argument = "fg=yellow";
        dollar-quoted-argument = "fg=yellow";
        rc-quote = "fg=magenta";
        dollar-double-quoted-argument = "fg=magenta,bold";
        back-double-quoted-argument = "fg=magenta,bold";
        back-dollar-quoted-argument = "fg=magenta,bold";
        redirection = "fg=blue,bold";
        comment = "fg=black,bold";
        arg0 = "fg=cyan";
        bracket-error = "fg=red,bold";
        bracket-level-1 = "fg=blue,bold";
        bracket-level-2 = "fg=green,bold";
        bracket-level-3 = "fg=magenta,bold";
        bracket-level-4 = "fg=yellow,bold";
        bracket-level-5 = "fg=cyan,bold";
      };
    };

    # Everything else with no structured HM option: raw setopt/bindkey/zstyle/vars.
    initContent = ''
      # --- shared/option.zsh (remaining setopts) ---
      setopt interactivecomments
      setopt magicequalsubst
      setopt nonomatch
      setopt notify
      setopt numericglobsort
      setopt promptsubst

      WORDCHARS='_-'
      PROMPT_EOL_MARK=""

      # --- shared/history.zsh (remaining setopt) ---
      setopt hist_verify

      # --- shared/time.zsh ---
      TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

      # --- shared/bindkey.zsh ---
      bindkey -e
      bindkey ' ' magic-space
      bindkey '^U' backward-kill-line
      bindkey '^[[3;5~' kill-word
      bindkey '^[[3~' delete-char
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[5~' beginning-of-buffer-or-history
      bindkey '^[[6~' end-of-buffer-or-history
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[Z' undo

      # --- shared/style.zsh (zstyle completion, beyond `enableCompletion`) ---
      zstyle ':completion:*:*:*:*:*' menu select
      zstyle ':completion:*' auto-description 'specify: %d'
      zstyle ':completion:*' completer _expand _complete
      zstyle ':completion:*' format 'Completing %d'
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
      zstyle ':completion:*' use-compctl false
      zstyle ':completion:*' verbose true
      zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

      # --- shared/color.zsh ---
      export LESS_TERMCAP_mb=$'\E[1;31m'
      export LESS_TERMCAP_md=$'\E[1;36m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;33m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[1;32m'
      export LESS_TERMCAP_ue=$'\E[0m'

      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    ''
    # --- Linux/color.zsh ---
    + lib.optionalString pkgs.stdenv.isLinux ''
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      export LS_COLORS="$LS_COLORS:ow=30;44:"
    ''
    # --- Darwin/color.zsh ---
    + lib.optionalString pkgs.stdenv.isDarwin ''
      export LSCOLORS=ExFxBxDxCxegedabagacad
    ''
    # --- shared/prompt.zsh + Darwin/prompt.zsh + Linux/prompt.zsh (external file) ---
    + ''
      source ~/.zconfig/prompt.zsh
    '';
  };
}
