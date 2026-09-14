# NixOS Constellation

[![xc compatible](https://xcfile.dev/badge.svg)](https://xcfile.dev)

Constellation builder, hosts with shared configuration

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
