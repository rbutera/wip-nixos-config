{ config, pkgs, lib, ... }:

let
  asdfDeps = with pkgs; [
    curl
    wget
    git
    gnused
    gnugrep
    coreutils
    gawk
    bashInteractive
    gnutar
    gzip
    bzip2
    xz
    zlib
    readline
    openssl
    which
    findutils
    gcc
    gnumake
    patchelf
    binutils
    pkg-config
    libffi
    libffi.dev
    ncurses
    ncurses.dev
  ];
  asdfSetupScript = pkgs.writeShellScriptBin "asdf-setup" ''
    . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
    export PATH="${lib.makeBinPath asdfDeps}:$PATH"

    if ! asdf plugin list | grep -q python; then
      asdf plugin add python
    fi
    if ! asdf plugin list | grep -q 3.12.5; then
      asdf install python 3.12.5
      asdf global python 3.12.5
    fi
    if ! asdf plugin list | grep -q nodejs; then
      asdf plugin add nodejs
      asdf install nodejs 14.15.2
      asdf install nodejs 16.17.0
      asdf install nodejs latest
      asdf global nodejs latest
    fi
  '';
in
{
  home.packages = with pkgs; [
    asdf-vm
    asdfSetupScript
  ];

  programs.zsh = {
    initExtra = ''
      # asdf setup
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
      export PATH="$HOME/.asdf/shims:$PATH"
    '';
  };

  home.activation = {
    asdfSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${asdfSetupScript}/bin/asdf-setup
    '';
  };
}
