{ pkgs, lib, ... }:

{
  # <install home-manager>
  # home-manager build --flake .#nixos
  # home-manager switch --flake 'git+ssh://git@github.com/liuhh666233/MyFlake#lxb' 

  # <install oh my fish>
  # curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
  # omf install lambda
  # omf theme lambda
  imports = [ ];

  # nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["tokenizer.json"];

  home.packages = [ pkgs.fd pkgs.oh-my-fish];

  # https://github.com/NixOS/nixpkgs/issues/196651
  # Fix /nix/store/0czacppvzvmiyx32p7j1d5p9mvjvsi0l-manual-combined/manual-combined.xml fails to validate
  manual.manpages.enable = false;

  programs.home-manager.enable = false;

  # ...other config, other config...
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      "gs" = "git status";
      "ga" = "git add";
      "gl" = "git log";
      "gp" = "git push";
      "gc" = "git commit -m";
      "gb" = "git branch";
      "gd" = "git diff";
      "te" = "trans -s en -t zh";
      "tz" = "trans -s zh -t en";
    };
    # macos 需要通过如下命令设置 fish_user_paths 变量，以保证能够找到macos本身安装的包，和nix安装的包
    # set -U fish_user_paths /nix/var/nix/profiles/default/bin /Users/lhh/.nix-profile/bin /run/current-system/sw/bin /usr/local/sbin /usr/local/bin /usr/bin 
    shellInit = ''
      set -U fish_user_paths /run/wrappers/bin /nix/var/nix/profiles/default/bin /Users/lhh/.nix-profile/bin /run/current-system/sw/bin /usr/local/sbin /usr/local/bin /usr/bin /opt/homebrew/bin
      
      source (${pkgs.z-lua}/bin/z --init fish | psub)

      set fzf_fd_opts --hidden --exclude=.git

      fzf_configure_bindings --git_status=\cg --history=\ch --processes=\co --variables --directory=\cd --git_log=\cl
    '';
    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
  };
}
