{
  description = "A constellation flake example";

  inputs = {
    constellation.url = "path:../";
    dev-tools.follows = "constellation/dev-tools";
    nixpkgs.follows = "constellation/nixpkgs";
    secrets.url = "path:./secrets";

    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nixos/nixos-hardware";
    };

    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
  };

  outputs =
    { self, constellation, ... }@inputs:
    (constellation.lib.mkConstellation {
      inherit self inputs;
    })
    // {
      checks.x86_64-linux = builtins.mapAttrs (
        _: member: member.config.system.build.toplevel
      ) self.nixosConfigurations;
    };
}
