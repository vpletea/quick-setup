# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.kernelParams = ["quiet"];
    
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-fe377078-8328-48d9-a112-e24aac047f96".device = "/dev/disk/by-uuid/fe377078-8328-48d9-a112-e24aac047f96";
  boot.initrd.luks.devices."luks-fe377078-8328-48d9-a112-e24aac047f96".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Install nerdfonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
    
  # Setting favorite apps in gnome
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      [org.gnome.shell]
      favorite-apps=['firefox.desktop', 'code.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']
    '';
  };  
  

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable pcscd service for yubikey
  services.pcscd.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Docker setup
  virtualisation.docker.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.valentin = {
    isNormalUser = true;
    description = "Valentin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ansible
    bitwarden
    docker
    firefox
    git
    gnome.gnome-terminal
    gnomeExtensions.dash-to-dock
    google-chrome
    htop
    k3d
    kubectl
    kubernetes-helm
    plymouth
    powertop
    terraform
    vim
    vlc
    vscode
    wget
    yubioath-flutter
  ];

  environment.gnome.excludePackages = with pkgs; [
      gnome-console
      gnome-photos
      gnome-text-editor
      gnome-tour
      gnome.atomix
      gnome.cheese
      gnome.epiphany
      gnome.evince
      gnome.geary
      gnome.gedit
      gnome.gnome-calendar
      gnome.gnome-characters
      gnome.gnome-clocks
      gnome.gnome-contacts
      gnome.gnome-maps
      gnome.gnome-music
      gnome.hitori
      gnome.iagno
      gnome.seahorse
      gnome.simple-scan
      gnome.tali
      gnome.totem
      gnome.yelp
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ## ZSH Setup
  programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  autosuggestions.extraConfig = {
  "ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE" = "20";
  };
  # Set zsh prompt for zsh autocomplete with up arrow
  promptInit = ''
  autoload -Uz history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
  bindkey "$terminfo[kcud1]" history-beginning-search-forward-end
  '';
  loginShellInit = "
  #Set favorite apps in dock and enable extensions
  dconf reset /org/gnome/shell/favorite-apps
  gnome-extensions enable dash-to-dock@micxgx.gmail.com
  ";
  syntaxHighlighting.enable = true;
  histFile = "$HOME/.histfile";
  histSize = 10000;
  enableBashCompletion = true;
  shellAliases = {
    ll = "ls -alh";
    ls = "ls --color=auto --group-directories-first";
    grep = "grep -n --color";
    kc = "k3d cluster create -p 80:80@loadbalancer -p 443:443@loadbalancer";
    kd = "k3d cluster delete";
    nr = "sudo nixos-rebuild switch";
    ne = "sudo nano /etc/nixos/configuration.nix";
    };
  };
  # programs.zsh.completionInit = ["emacs"];
  environment.pathsToLink = [ "/share/zsh" ];
  
  ## Starship prompt setup
  programs.starship = {
  enable = true;
  settings = {
     kubernetes = {
     disabled = false;
     };
   };
  };

 
  # Set default shell to zsh
  users.defaultUserShell = pkgs.zsh;

  # List services that you want to enable:
  

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}

