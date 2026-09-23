# Example Flake

This is a simple example of a constellation, nspawn containers are built and run, metal is built
only

## Tasks

### build

Inputs: MEMBER

```bash
nixos-rebuild build --no-link --flake .#$MEMBER
```

### create

```bash
members=$(nix eval --raw .#nixosConfigurations --apply '
    members:
    builtins.concatStringsSep " " (
        builtins.filter
            (name: members.${name}.config.boot.isNspawnContainer)
            (builtins.attrNames members)
    )
')

for member in $members; do
    local=$(nix eval --raw ".#nixosConfigurations.${member}._module.specialArgs.manifest.network.addresses.lan")
    host=$(echo $local | awk -F"." '{ print $1 "." $2 "." $3 ".1" }')

    sudo nixos-container create $member \
        --flake "git+file:..?dir=example#$member" \
        --host-address $host --local-address $local
done

[ ! -L .tmp ] || rm -- .tmp
```

### start

Inputs: MEMBER

```bash
sudo nixos-container start $MEMBER
```

### shell

Inputs: MEMBER

```bash
sudo nixos-container root-login $MEMBER
```

### rebuild

```bash
members=$(nix eval --raw .#nixosConfigurations --apply '
    members:
    builtins.concatStringsSep " " (
        builtins.filter
            (name: members.${name}.config.boot.isNspawnContainer)
            (builtins.attrNames members)
    )
')

for member in $members; do
    sudo nixos-container update $member \
        --flake "git+file:..?dir=example#$member"
done

[ ! -L .tmp ] || rm -- .tmp
```

### stop

Inputs: MEMBER

```bash
sudo nixos-container stop $MEMBER
```

### destroy

```bash
members=$(nix eval --raw .#nixosConfigurations --apply '
    members:
    builtins.concatStringsSep " " (
        builtins.filter
            (name: members.${name}.config.boot.isNspawnContainer)
            (builtins.attrNames members)
    )
')

for member in $members; do
    sudo nixos-container destroy $member
done
```
