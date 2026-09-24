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

Inputs: MEMBERS

Environment: MEMBERS=

```bash
if [ -z "$MEMBERS" ]; then
    MEMBERS=$(nix eval --raw .#lib.nspawnMembers --apply 'builtins.concatStringsSep " "')
fi

for member in $MEMBERS; do
    local=$(nix eval --raw ".#nixosConfigurations.${member}._module.specialArgs.manifest.network.addresses.lan")
    host=$(echo $local | awk -F"." '{ print $1 "." $2 "." $3 ".1" }')

    sudo nixos-container create $member \
        --flake "git+file:..?dir=example#$member" \
        --host-address $host --local-address $local
done

[ ! -L .tmp ] || rm -- .tmp
```

### start

Inputs: MEMBERS

Environment: MEMBERS=

```bash
if [ -z "$MEMBERS" ]; then
    MEMBERS=$(nix eval --raw .#lib.nspawnMembers --apply 'builtins.concatStringsSep " "')
fi

for member in $MEMBERS; do
    sudo nixos-container start $member
done
```

### shell

Using `sudo nixos-container root-login $MEMBER`, `xc shell` suspends when the container shutdown
starts, and prevents it from shutting down until the shell job is resumed. When using
`machinectl shell` directly, the shell terminates and the machine shuts down as expected.

Inputs: MEMBER

```bash
sudo machinectl shell "root@$MEMBER"
```

### rebuild

Inputs: MEMBERS

Environment: MEMBERS=

```bash
if [ -z "$MEMBERS" ]; then
    MEMBERS=$(nix eval --raw .#lib.nspawnMembers --apply 'builtins.concatStringsSep " "')
fi

for member in $MEMBERS; do
    sudo nixos-container update $member --flake "git+file:..?dir=example#$member"
done

[ ! -L .tmp ] || rm -- .tmp
```

### stop

Inputs: MEMBERS

Environment: MEMBERS=

```bash
if [ -z "$MEMBERS" ]; then
    MEMBERS=$(nix eval --raw .#lib.nspawnMembers --apply 'builtins.concatStringsSep " "')
fi

for member in $MEMBERS; do
    sudo nixos-container stop $member
done
```

### terminate

Inputs: MEMBERS

Environment: MEMBERS=

```bash
if [ -z "$MEMBERS" ]; then
    MEMBERS=$(nix eval --raw .#lib.nspawnMembers --apply 'builtins.concatStringsSep " "')
fi

for member in $MEMBERS; do
    sudo nixos-container terminate $member
done
```

### destroy

Inputs: MEMBERS

Environment: MEMBERS=

```bash
if [ -z "$MEMBERS" ]; then
    MEMBERS=$(nix eval --raw .#lib.nspawnMembers --apply 'builtins.concatStringsSep " "')
fi

for member in $MEMBERS; do
    sudo nixos-container destroy $member
done
```
