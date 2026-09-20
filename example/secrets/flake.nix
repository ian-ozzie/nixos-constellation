{
  description = "Example secrets flake";

  outputs = _: {
    constellation = import ./constellation.nix;
  };
}
