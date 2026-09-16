inputs:
let
  private = inputs.secrets.constellation inputs;
in
{
  inherit private;

  domain = "example.test";
  name = "example";
  network = { };
  services = { };

  core = [
    ({ pkgs, ... }: {
      nix.settings.trusted-users = [ "@wheel" ];

      environment = {
        systemPackages = with pkgs; [
          cowsay
        ];
      };
    })
  ];

  members = {
    foo = import ./hosts/foo inputs;
    bar = import ./hosts/bar inputs;
    baz = import ./hosts/baz inputs;
    laptop = import ./hosts/laptop inputs;
  };
}
