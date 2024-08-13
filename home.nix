{ config, pkgs, lib, variables, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/asdf.nix
    ./modules/zsh.nix
    ./modules/nvim.nix
  ];    
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = variables.username;
  home.homeDirectory = "/home/${variables.username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = variables.stateVersion; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # System Information and Monitoring
    fastfetch
    htop
    ncdu

    # Version Control and Development Tools
    gh
    git-filter-repo
    git-lfs
    git-secret
    delta
    gitflow
    asdf-vm
    pyenv
    tfswitch
    virtualenv

    # Programming Languages and Runtimes
    go
    perl
    mono
    lua
    SDL2

    # Build Tools and Package Managers
    yarn

    # Text Processing and Search
    ack
    bat
    fd
    fzf
    fzy
    ripgrep
    jq
    peco

    # File Management and Navigation
    broot
    tree
    trash-cli
    eza
    rename

    # Compression and Archives
    p7zip
    unzip
    zip
    xz

    # Network Tools
    aria2
    caddy
    httpie
    mkcert
    wget
    wireguard-tools

    # Clipboard Management
    wl-clipboard
    clipman

    # Security and Encryption
    gnupg
    gnutls
    openssl

    # Documentation and Markdown
    glow
    pandoc
    sphinx
    tldr

    # Database
    postgresql_14

    # File Systems
    ntfs3g
    fuse

    # Web Browsers
    floorp

    # Fonts
    nerdfonts

    # Libraries and Dependencies
    boost
    cairo
    fb303
    fbthrift
    fizz
    folly
    glib
    gobject-introspection
    guile
    harfbuzz
    krb5
    leptonica
    libass
    libbluray
    librsvg
    libssh2
    p11-kit
    readline
    unbound
    vapoursynth
    wangle
    libwebp
    wimlib
    zlib

    # Text and Code Analysis
    ctags
    shellcheck
    stylua

    # Internationalization
    gettext

    # Task Management
    todoist

    # Terminal Multiplexer
    tmux

    # Image Processing
    tesseract

    # Version Control Helpers
    bfg-repo-cleaner

    # Development Watchers
    watchman

    # Custom Certificate Authority
    mkcert
    sbctl
];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-variables.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-variables.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rai/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # configure sane defaults in vim
  programs.vim = {
    enable = true;
    settings = {
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };
    extraConfig = ''
      set softtabstop=2
      set autoindent
      set smartindent
    '';
  };

}
