{ sops-nix, ... }:
{
  core = [ sops-nix.nixosModules.sops ];
  hostsDir = ./hosts;
}
