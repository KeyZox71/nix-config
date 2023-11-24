{ config, pkgs, ... }

{
	nixpkgs.config.allowUnfree = true;

	imports =
	[
		inputs.home-manager.nixosModules.home-manager

		./hardware-configuration.nix
	];

	sessionVariables = {
		# USER = "adjoly";
		# MAIL = "adjoly@student.42angouleme.fr";
		EDITOR = "vim";
    	VISUAL = "codium";
		KITTY_ENABLE_WAYLAND = "1";
	};

	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.efi.efiSysMountPoint = "/boot";
	boot.blacklistedKernelModules = [ "nouveau" ]; # nouveau hate club
	boot.loader.grub.device = "nodev";
	boot.loader.grub.enable = true;
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.useOSProber = true;

	networking.hostName = "LAPTOPNIXOS-ADAM";
	networking.networkmanager.enable = true;
	networking.firewall.enable = false;
	networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

	time.timeZone = "Europe/Paris";

	i18n.defaultLocale = "fr_FR.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADRESS = "fr_FR.UTF-8";
		LC_IDENTIFICATION = "fr_FR.UTF-8";
		LC_MEASUREMENT = "fr_FR.UTF-8";
		LC_MONETARY = "fr_FR.UTF-8";
		LC_NAME = "fr_FR.UTF-8";
		LC_NUMERIC = "fr_FR.UTF-8";
		LC_PAPER = "fr_FR.UTF-8";
		LC_TELEPHONE = "fr_FR.UTF-8";
		LC_TIME = "fr_FR.UTF-8";
	};

	hardware.opengl.enable = true;
	hardware.opengl.driSupport32Bit = true;

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		nvidiaPatches = true;
	};

	programs.zsh.enable = true;

	services = {
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			wireplumber.enable = true;
    	};
    	xserver = {
			layout = "us";
			xkbVariant = "altgr-intl";
			libinput = {
				enable = true;
				mouse.accelProfile = "flat";
				touchpad.accelProfile = "flat";
    		};

		};
		fstrim.enable = true;

	};
	security.rtkit.enable = true;
	services.xserver.libinput.enable = true;

	users.users.yosyo = {
		shell = pkgs.zsh;
		isNormalUser = true;
		extraGroups = [ "networkmanager" "wheel" "audio" "input" "video" "seat" "sudo" ]; # Enable ‘sudo’ for the user.
		# packages = with pkgs; [
		# ];
  	};

	programs.thunar.enable = true;
	services.gvfs.enable = true; # Mount, trash, and other functionalities
	services.tumbler.enable = true; # Thumbnail support for images

	environment.systemPackages = with pkgs; [

    	# essentials / utils / libs / others / shitposting
		vlc vim wget curl neofetch wayland wayland-protocols libva-utils vulkan-tools vulkan-headers vulkan-validation-layers libcamera xdg-utils mate.mate-polkit killall brightnessctl gamescope git dunst pulseaudio btop flameshot
    	# apps
    	discord brave spotify qbittorrent vscodium kitty thunar
    	# rice
    	swww macchina zsh wofi inputs.hyprsome.packages."${pkgs.system}".default inputs.gross.packages."${pkgs.system}".default gammastep

	];

	fonts = {
		fonts = with pkgs; [ jetbrains-mono google-fonts ];
	};
	xdg = {
    	sounds.enable = true;
    	portal = {
			enable = true;
    		xdgOpenUsePortal = true;
			extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		};
	};
	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		extraSpecialArgs = { inherit inputs; };
		users.adjoly = import ./hm/home.nix;
	};
	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
		};
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 7d";
		};
	};
	system.stateVersion = "23.05";
}