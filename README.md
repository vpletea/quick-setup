# My NixOS Setup
  Using nixos for my workstation with luks encryption. Make sure your luks section is adapted to your system:

      boot.initrd.luks.devices."luks-5fa26d8a-9213-4933-be9b-804ccc686401".device = "/dev/disk/by-uuid/5fa26d8a-9213-4933-be9b-804ccc686401";
      boot.initrd.luks.devices."luks-5fa26d8a-9213-4933-be9b-804ccc686401".keyFile = "/crypto_keyfile.bin";
  
  Those uuid's are different from install to install.
