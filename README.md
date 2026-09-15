# NixOS Constellation

[![xc compatible](https://xcfile.dev/badge.svg)](https://xcfile.dev)

Constellation builder, hosts with shared configuration

## Facter

This has been built around nixos-facter, gather facts from metal hosts:

```bash
sudo nix run nixpkgs#nixos-facter -- -o facter.json
```

## Tasks

### lock

Lock flake inputs

```bash
nix flake lock
```

### update

Update all/specific input

Inputs: INPUT

Environment: INPUT=

```bash
nix flake update $INPUT

cd example
nix flake update
```

### check

Check flake outputs

```bash
nix flake check
```

### inputs

Check flake inputs

```bash
nix flake metadata
```

### test

Evaluate all supported systems and run checks for the current system, and build example containers.
Used by CI

```bash
nix flake check --all-systems
cd example
nix flake check
```
