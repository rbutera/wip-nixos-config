{ config, pkgs, variables, ... }:

{
  programs.git = {
    enable = true;
    userName = variables.fullName;
    userEmail = variables.email;
    
    aliases = {
      # Existing aliases
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";

      # New aliases from your .gitconfig
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
      fuck = "!git reset HEAD --hard && git clean -fd";
      undo = "!git reset --soft HEAD^";
      s = "status -s";
      d = "!git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat";
      di = "!d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d";
      p = "!git pull; git submodule foreach git pull origin master";
      c = "clone --recursive";
      cnv = "!git add -A && git commit --no-verify -av -m";
      ca = "!git add -A && git commit -av -m";
      caz = "!git add -A && git cz";
      go = "checkout -B";
      credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f";
      reb = "!r() { git rebase -i HEAD~$1; }; r";
      fb = "!f() { git branch -a --contains $1; }; f";
      ft = "!f() { git describe --always --contains $1; }; f";
      fc = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f";
      fm = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f";
      dm = "git checkout master && !git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d";
      add-commit = "!git add -A && git commit";
      getchanges = "fetch; git rebase -i origin/master";
      pu = "push -v --tags";
    };

    extraConfig = {
      github.user = variables.githubUsername;

      core = {
        editor = "nvim";
        autocrlf = false;
        excludesfile = "~/.gitignore";
        attributesfile = "~/.gitattributes";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        trustctime = false;
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push = {
        default = "matching";
        followTags = true;
        autoSetupRemote = true;
      };
      apply.whitespace = "fix";
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      merge = {
        log = true;
        conflictstyle = "diff3";
      };
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
          pushInsteadOf = [ "github:" "git://github.com/" ];
        };
        "git://github.com/" = {
          insteadOf = "github:";
        };
        "git@gist.github.com:" = {
          insteadOf = "gst:";
          pushInsteadOf = [ "gist:" "git://gist.github.com/" ];
        };
        "git://gist.github.com/" = {
          insteadOf = "gist:";
        };
      };
      mergetool.keepBackup = true;
      mergetool.prompt = false;
      fetch.prune = true;
      diff.colorMoved = "default";
    };
    
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };
    
    ignores = [
      ".DS_Store"
      "*.swp"
      ".vscode"
      "node_modules"
    ];
  };

}
