# My NixOS Setup
  Using nixos for my workstation with luks encryption. Make sure your luks section is adapted to your system - those uuid's are different from install to install:

      boot.initrd.luks.devices."luks-5fa26d8a-9213-4933-be9b-804ccc686401".device = "/dev/disk/by-uuid/5fa26d8a-9213-4933-be9b-804ccc686401";
      boot.initrd.luks.devices."luks-5fa26d8a-9213-4933-be9b-804ccc686401".keyFile = "/crypto_keyfile.bin";

  Another thing to keep in mind - gnome favorite apps will be reset to the list in configuration.nix at every login.
