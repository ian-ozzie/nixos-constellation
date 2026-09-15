# I have this in a separate secrets flake, holds configuration I don't want public. Uses SOPS for genuine secrets
{ sops-nix, ... }:
{
  core = [ sops-nix.nixosModules.sops ];

  members = {
    foo = {
      manifest = {
        network.addresses.vpn = "127.1.2.3";
        network.addresses.wan = "127.2.3.4";
      };

      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            yazi
          ];
        })
      ];
    };
  };
}
