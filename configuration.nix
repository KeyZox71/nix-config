{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  environment = {
    sessionVariables = {
    };
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.loader.grub.device = "nodev";
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "PC-ADAMNIX"; # Define your hostname.

  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8 1.1.1.1 192.168.1.1" ];

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.displayManager.defaultSession = "gnome";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    layout = "us";
    videoDrivers = [ "nvidia" ];
    xkbVariant = "intl";
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  programs.zsh.enable = true;

  console.keyMap = "us-acentos";

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.libinput.enable = true;

  users.users.adjoly = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "i2c" "kvm" "libvirt" "input" ];
  };

  users.extraGroups.vboxusers.members = [ "adjoly" ];

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "adjoly";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
#utils / utils / other
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neofetch
    curl
    ddcutil
    solaar
#communication
    beeper
    discord
    slack
    signal-desktop
#internet
    brave
    nextcloud-client
    firefox
    spotify
    authy
    plex-desktop
#dev
    git
    github-cli
    vscodium
    gcc
    readline
    clang_17
    SDL2
    gnumake
    norminette
#tool for de
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.brightness-control-using-ddcutil
  ];

  # List services that you want to enable:
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
