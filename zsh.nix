{ ... }:
{
    programs.zsh = {
    enable = true;
    completionInit = ''
      source $HOME/.zconfig/main.zsh
    '';
    syntaxHighlighting.enable = true;
  };
}