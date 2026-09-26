# NixOS Constellation

[![xc compatible](https://xcfile.dev/badge.svg)](https://xcfile.dev)

Constellation builder, members with shared configuration.

## Goal

This project is to try to bring back what I previously had with Puppet, where hosts could
reconfigure themselves based on facts that were reported back by others to the Puppet Master. While
NixOS has been great at configuring individual machines, multi-host configuration was something that
I've been missing. While this doesn't have the same automatic flexibility Puppet provides, the
Constellation allows members to access information about other members to configure themselves.

The included example was used to mimic how I intend to use this, as well as testing the library, but
is an **example only**. Secrets are in the clear intentionally and aren't expected to be used in a
live scenario. Something like [sops-nix](https://github.com/mic92/sops-nix) should be used to
prevent these secrets from being exposed in the clear in the nix store.

## Facter

This has been built with nixos-facter in mind, gather facts from host members:

```bash
sudo nix run nixpkgs#nixos-facter -- -o facter.json
```

Facter is opt-in, nothing here requires it, and only applies to `host` members.

## Disko

Disko is also opt-in, and passing in a disko configuration will add the disko module:

```nix
  disko = ./storage.nix;
```

The disko input is needed on the consumer, and this only applies to `host` members.

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
