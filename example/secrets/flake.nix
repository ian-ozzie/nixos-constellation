{
  description = "Example secrets flake";

  outputs = _: {
    constellation = import ./default.nix;
  };
}
