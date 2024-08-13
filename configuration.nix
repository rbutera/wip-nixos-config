{ config, pkgs, variables, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./bootloader.nix
    ];

  networking.hostName = variables.hostname;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  time.timeZone = variables.timezone;

  i18n.defaultLocale = "${variables.locale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${variables.locale}";
    LC_IDENTIFICATION = "${variables.locale}";
    LC_MEASUREMENT = "${variables.locale}";
    LC_MONETARY = "${variables.locale}";
    LC_NAME = "${variables.locale}";
    LC_NUMERIC = "${variables.locale}";
    LC_PAPER = "${variables.locale}";
    LC_TELEPHONE = "${variables.locale}";
    LC_TIME = "${variables.locale}";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  console.keyMap = "uk";

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${variables.username} = {
    isNormalUser = true;
    description = "${variables.fullName}";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    shell = pkgs.zsh;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = variables.username;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  virtualisation.vmware.guest.enable = variables.vmware;

  services.openssh.enable = true;

  system.stateVersion = variables.stateVersion;

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "unstable=https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz"
    ];
  };

  system.autoUpgrade = {
    enable = variables.autoupgrade;
  };

  programs.git.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE ${variables.username} WITH LOGIN PASSWORD '${variables.username}' CREATEDB;
      CREATE DATABASE ${variables.username};
      GRANT ALL PRIVILEGES ON DATABASE ${variables.username} TO ${variables.username};
    '';
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
  ];
}
