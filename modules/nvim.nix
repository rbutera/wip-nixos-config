{ config, pkgs, lib, ... }:

let
  neovim-0-9 = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "0.9.4";
  });
  astronvimConfigRepo = "https://github.com/rbutera/nixos_astronvim_config.git";
  astronvimConfigDir = "${config.home.homeDirectory}/.config/nvim";
in
{
  programs.neovim = {
    enable = true;
    package = neovim-0-9;
    viAlias = false;
    vimAlias = false;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      gcc
      nodejs
      python3
      ripgrep
      fd
      git
      gnumake
      unzip
      nil
      cargo
    ];
  };

  home.packages = with pkgs; [
    typescript-language-server
    vscode-langservers-extracted
    rust-analyzer
    gopls
    rust-analyzer
    lua-language-server
    nil # This is the Nix language server
    gopls
    gleam
    pyright
    tailwindcss-language-server
    svelte-language-server
    yaml-language-server
    dockerfile-language-server-nodejs
    bash-language-server
    # Add other LSP servers as needed
  ];

  home.activation = {
    cloneAstroNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${astronvimConfigDir}" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone ${astronvimConfigRepo} ${astronvimConfigDir}
      else
        $DRY_RUN_CMD cd ${astronvimConfigDir} && ${pkgs.git}/bin/git pull
      fi
    '';

     downloadNvimPlugins = lib.hm.dag.entryAfter ["symlinkAstroNvimConfig"] ''
      if [ ! -d "${config.home.homeDirectory}/.local/share/nvim/lazy" ]; then
        $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.local/share/nvim/lazy"
      fi
      $DRY_RUN_CMD ${pkgs.neovim}/bin/nvim --headless -c 'lua require("lazy").sync()' -c 'qa'
    '';
  };
}
