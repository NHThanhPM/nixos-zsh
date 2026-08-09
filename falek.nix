{
    description = "my zsh configuration for nixos";

    output = {
        homeConfigurations.zsh = import zsh.nix;
    };
}