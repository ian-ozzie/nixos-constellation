{ sops-nix, ... }@inputs:
{
  core = [ sops-nix.nixosModules.sops ];

  members = {
    foo = import ./hosts/foo inputs;
    laptop = import ./hosts/laptop inputs;
  };
}
