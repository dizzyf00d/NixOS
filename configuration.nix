## Edit this configuration file to define what should be installed on
## your system.  Help is available in the configuration.nix(5) man page
## and in the NixOS manual (accessible by running 'nixos-help').

## Remember to build and switch to the new configuration
## making it the boot default and installing updates:
## $ nixos-rebuild switch --upgrade

## Rollback changes to the configuration
## switching to the previous generation: 
## $ nixos-rebuild switch --rollback

## are comments - not to be touched.
#are commented out variables.

{ config, pkgs, ... }:

{
  environment.variables.EDITOR = "vim";

  imports =
    [ ## Include the results of the hardware and network scan.
      ./hardware-configuration.nix
      #./network-configuration.nix
    ]; ##end imports

  ## Use the latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  ## Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  #boot.loader.grub.efiSupport = true;
  #boot.loader.grub.efiInstallAsRemovable = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.useOSProber = true;
  ## Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; ## or "nodev" for efi only

  networking.hostName = "nixos";      ## Define your hostname.
  #networking.wireless.enable = true; ## Enables wireless support via wpa_supplicant.

  ## Configure network proxy if necessary
  #networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ## Enable networking
  ## The global useDHCP flag is deprecated, therefore explicitly set to false here.
  ## Per-interface useDHCP will be mandatory in the future, so this generated config
  ## replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;
  networking.networkmanager.enable = true;

  ## Set your time zone.
  time.timeZone = "Europe/London";

  ## Font size.
  fonts.fontconfig.dpi = 96;

  ## Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  }; ##end console

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  }; ##end i18n.extraLocaleSettings

  ## Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = 
      [ ## Enable video drivers.
        #"intel" 
        "amdgpu"
      ]; ##end videoDrivers

    ## Enable the Desktop Manager.
    desktopManager = {
    #  xterm.enable = false;
    ## Desktop Manager name. (e.g. 'xfce', 'gnome', 'kde')
       kde = {
          enable = true;
          noDesktop = false;
          enableXfwm = false;
       };
    }; ##end desktopManager

    ## Enable the Window Manager.
#    windowManager = {
#      ## Window Manager name. (e.g. 'awesome', 'qtile', 'xmonad')
#      awesome = {
#        enable = true;
#        luaModules = with pkgs.luaPackages; 
#        [
#          luarocks     ## is the package manager for Lua modules.
#          luadbi-mysql ## Database abstraction layer.
#        ];
#        #config = pkgs.lib.readFile ./xmonad-config/Main.hs;
#        #enableContribAndExtras = true;
#        #extraPackages = haskellPackages: 
#        #[
#          #haskellPackages.xmonad         ## is a tiling window manager for X.
#          #haskellPackages.xmonad-contrib ## Third party configs, scripts, etc.
#          #haskellPackages.xmonad-extras  ## Various modules for xmonad.
#        #];
#      };
#    };##end windowManager

    ## Enable the Display Manager.
    displayManager = {
      sddm.enable = true;               ## Display Manager. (e.g. 'gdm', 'sddm')
    #  defaultSession = "none+awesome"; ## Desktop+Window Manager. (e.g. "kde+i3")
    }; ##end displayManager
  }; ##end services.xserve

  ## Configure keymap in X11
  services.xserver.layout = "gb";
  #services.xserver.xkbOptions = "eurosign:e";

  ## Enable CUPS to print documents.
  services.printing.enable = true;

  ## Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    ## If you want to use JACK applications, uncomment this
    #jack.enable = true;

    ## use the example session manager (no others are packaged yet so this is enabled by default,
    ## no need to redefine it in your config for now)
    #media-session.enable = true;
  }; ##end services.pipewire

  ## OpenGL configuration.
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  }; ##end hardware.opengl

  ## Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;
  
  ## Required for screen-lock-on-suspend functionality.
#  services.logind.extraConfig = {
#    LidSwitchIgnoreInhibited = false;
#    HandleLidSwitch = suspend;
#    HoldoffTimeoutSec = 10;
#  }; ##end services.logind.extraConfig

  ## Define a user account. Don't forget to set a password with 'passwd'.
  users.users.james = {
    isNormalUser = true;
    group = "users";
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
    createHome = true;
    home = "/home/james";
  }; ##end users.users

  ## Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "nixos";

  ## Allow packages with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  ## Install broadcom drivers.
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    
  ## List packages installed in system profile. To search, run:
  ## $ nix search wget
  environment.systemPackages = with pkgs; 
  [
    ## Command Line and Terminal:
    wget      ## Tool for retrieving files using HTTP, HTTPS, and FTP.
    git       ## Distributed version control system.
    alacritty ## Terminal emulator.
    htop      ## Interactive process viewer.
    killall   ## Command line utility to kill processes by name.

    ## Text Editors:
    vim       ## Popular clone of the VI editor.
    emacs     ## GNU text editor.
    notepadqq ## Notepad++-like editor.
    vscodium  ## Visual Code without Microsoft branding, telemetry or licensing.

    ## GUI Programs:
    firefox            ## Web browser built from Firefox source tree.
    pcmanfm            ## File manager with GTK interface.
    spotify            ## Play music from the Spotify music service.
    mpv                ## General-purpose video player.
    gimp-with-plugins  ## GNU Image Manipulation Program.
    bitwarden          ## Secure and free password manager.
    dropbox            ## Online stored folders (daemon version).
    qbittorrent        ## BitTorrent client that uses libtorrent.
    libreoffice-fresh  ## Productivity software suite.
    ungoogled-chromium ## Chromium with dependencies on Google web services removed.
    unzip              ## Extraction utility to uncompress .zip files.

    ## Other:
    #haskellPackages.xmobar ## Minimalistic text based status bar.
    #nitrogen               ## Wallpaper browser and setter for X11.
    #picom                  ## Compositing manager for X servers.
    #dmenu                  ## Menu for the X Window System.
    networkmanager          ## Network configuration and management tool.
    #networkmanagerapplet   ## NetworkManager control applet for GNOME.
  ]; ##end environment.systemPackages

  ## Some programs need SUID wrappers, can be configured further or are
  ## started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #}; ##end programs.gnupg.agent

  ## List services that you want to enable:

  ## Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  ## Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  ## Or disable the firewall altogether.
  #networking.firewall.enable = false;

  ## This value determines the NixOS release from which the default
  ## settings for stateful data, like file locations and database versions
  ## on your system were taken.  It's perfectly fine and recommended to leave
  ## this value at the release version of the first install of this system.
  ## Before changing this value read the documentation for this option
  ## (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";

}