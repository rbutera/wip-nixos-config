{ config, pkgs, ... }:

let
  vars = import ./variables.nix;
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      ./bootloader.nix
    ];

  networking.hostName = vars.hostname;
  networking.networkmanager.enable = true;

  time.timeZone = vars.timezone;

  i18n.defaultLocale = "${vars.locale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${vars.locale}";
    LC_IDENTIFICATION = "${vars.locale}";
    LC_MEASUREMENT = "${vars.locale}";
    LC_MONETARY = "${vars.locale}";
    LC_NAME = "${vars.locale}";
    LC_NUMERIC = "${vars.locale}";
    LC_PAPER = "${vars.locale}";
    LC_TELEPHONE = "${vars.locale}";
    LC_TIME = "${vars.locale}";
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

  users.users.${vars.username} = {
    isNormalUser = true;
    description = "${vars.fullName}";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    shell = pkgs.zsh;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = vars.username;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  virtualisation.vmware.guest.enable = vars.vmware;

  services.openssh.enable = true;

  system.stateVersion = vars.stateVersion;

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
    enable = vars.autoupgrade;
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
      CREATE ROLE ${vars.username} WITH LOGIN PASSWORD '${vars.username}' CREATEDB;
      CREATE DATABASE ${vars.username};
      GRANT ALL PRIVILEGES ON DATABASE ${vars.username} TO ${vars.username};
    '';
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
  ];
}
