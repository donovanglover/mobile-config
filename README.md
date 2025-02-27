# mobile-config

My NixOS configuration for running NixOS on a PinePhone.

![A screenshot of a phone running NixOS and Phosh with the kitty terminal emulator.](./.github/screenshots/phosh.png)
<sub>[microfetch](https://github.com/NotAShelf/microfetch) by NotAShelf, [Beautiful freedom](https://forums.puri.sm/t/tutorial-add-a-custom-background-in-phosh/13385/23) by Ick - [CC-BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en)</sub>

## Features

- Working phone calls
- Working SMS
- Working camera
- 4G support
- Video support
- `mobile-config-firefox`

## Usage

Build and start a virtual machine of the phone on x86_64-linux:

```fish
nixos-rebuild build-vm --flake .#mobile-nixos-vm && ./result/bin/run-mobile-nixos-vm
```

Build and deploy on reboot to the aarch64 phone:

```fish
nixos-rebuild boot --flake .#mobile-nixos --target-host YOUR_PINEPHONE_ADDRESS --use-remote-sudo
```
