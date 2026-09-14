inputs:
let
  private = import ./private.nix inputs;
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
    foo = {
      manifest = {
        identity.hostName = "foo";
        kind = "container";
        network.addresses.lan = "10.233.123.2";
        stateVersion = "26.05";
        system = "x86_64-linux";
      };
    };

    bar = {
      manifest = {
        identity.hostName = "bar";
        kind = "container";
        network.addresses.lan = "10.233.123.3";
        stateVersion = "26.05";
        system = "x86_64-linux";
      };
    };

    baz = {
      manifest = {
        identity.hostName = "baz";
        kind = "container";
        network.addresses.lan = "10.233.123.4";
        stateVersion = "26.05";
        system = "x86_64-linux";
      };
    };
  };
}
