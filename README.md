# mobile-config

My NixOS configuration for running NixOS on a phone.

## Features

- 4G support
- Video support

## Usage

```fish
nixos-rebuild build-vm --flake .#mobile-nixos-vm && ./result/bin/run-mobile-nixos-vm
```
