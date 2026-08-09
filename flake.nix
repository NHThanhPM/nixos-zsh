{
    description = "my zsh configuration for nixos";

    outputs = { ... }: {
        homeConfigurations.zsh = import ./zsh.nix;
    };
}