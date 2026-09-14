# Example Flake

This is a simple example with a constellation of containers

## Tasks

### create

Inputs: SUBNET

Environment: SUBNET=10.233.123

```bash
counter=1
for host in foo bar baz; do
    ((counter++))

    sudo nixos-container create $host \
        --flake "git+file:..?dir=example#$host" \
        --host-address $SUBNET.1 \
        --local-address $SUBNET.$counter
done
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
for host in foo bar baz; do
    sudo nixos-container update $host \
        --flake "git+file:..?dir=example#$host"
done
```

### stop

Inputs: MEMBER

```bash
sudo nixos-container stop $MEMBER
```

### destroy

```bash
for host in foo bar baz; do
    sudo nixos-container destroy $host
done
```
