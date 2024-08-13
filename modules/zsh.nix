{ pkgs, config, lib, ... }:
{
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "jeffreytse/zsh-vi-mode"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
          { name = "agkozak/zsh-z"; }
        ];
      };

      initExtra = ''
        # allows arbitrary binaries downloaded through channels such as mason to be run
        export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')

        # asdf setup
        . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh

        # functions etc
        # Detect which `ls` flavor is in use
          if ls --color >/dev/null 2>&1; then # GNU `ls`
            colorflag="--color"
          else # OS X `ls`
            colorflag="-G"
          fi

          export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

          function gcap() {
            g ca "$@" && git push
          }

          unalias vim 2>/dev/null

          alias ls=' eza --group-directories-first'
          alias la=' ls -a'
          alias ll=' ls --git -l'

          function czm() {
            command="chezmoi edit --apply $@"
            echo "$command"
            eval $command
            rr
          }

          function cd() {
            builtin cd "$@" && echo $PWD && ls;
          }

          function standup2slack(){
            npx md2slack today | pbcopy;
            echo "Will send the following to slack:\n"
            echo "$(pbpaste)"
            echo "\n"
            read -q "REPLY?Continue?"

            case "$REPLY" in
              y|Y ) echo "yes";;
              n|N ) echo "no";;
              * ) echo "invalid";;
            esac

            echo "Continuing..."
            npx md2slack today | pbcopy;
            osascript -e 'tell application "Keyboard Maestro Engine" to do script "7DF44845-9F4C-40C2-8B8A-8A780D70936F"'
          }

          function gsync() {
            git fetch --all && for branch in $(git branch | sed '/*/{$q;h;d};$G' | tr -d '*') ; do git checkout $branch && git merge --ff-only || break ; done
          }

          function get_ssm_dotfile() {
            NAME=$1
            ENVIRONMENT=$2
            if [[ -z "$ENVIRONMENT" ]]; then
              ENVIRONMENT="STAGE"
            fi
            if [[ -z "$NAME" ]]; then
              echo "MISSING DOTFILE NAME, EXITING!"
              return 1
            else
              aws ssm get-parameters --name "/$ENVIRONMENT/dotfiles/$NAME" --with-decryption
            fi
          }

          function gcar() {
            echo "Quickly releasing change..."
            gca "$@" && \
            {
              if [ -f yarn.lock ]; then
                yarn release --force
              elif [ -f pnpm-lock.yaml ]; then
                pnpm release --force
              else
                echo "No lock file found for Yarn or PNPM. Please ensure you are in the correct project directory."
                return 1
              fi
            }
          }

          function tmux_auto() {
              if tmux ls &>/dev/null; then
                  tmux attach-session -t 0
              else
                  tmux new-session
              fi
          }
      '';

      envExtra = ''
        export ZDOTDIR="$HOME/.config/zsh"
      '';

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "-" = "cd -";
        g = " git";
        l = "ls -lF --color";
        la = "ls -laF --color";
        lsd = "ls -lF --color | grep --color=never '^d'";
        ls = "command ls --color";
        sudo = "nocorrect sudo";
        raisync = "rsync -rvzP";
        pbpaste = "wl-paste";
        pbcopy = "wl-copy";
        czd = "chezmoi diff";
        czu = "chezmoi update";
        nvimcfg = "nv ~/.config/nvim/lua/user";
        gitroot = "cd $(git rev-parse --show-toplevel)";
        gca = "g ca";
        nvim_config = "nv ~/.config/nvim/lua/user/init.lua";
        sudonvim = "sudo -E nvim";
        nixrebuild = "nixos-rebuild switch";
        homeswitch = "home-manager switch";
        fr = "nixos-rebuild switch --flake ~/nixos-config";
      };

  };
}
