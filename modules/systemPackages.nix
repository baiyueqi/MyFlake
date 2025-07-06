{ config, pkgs, lib, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Python
    # python3
    # (python3.withPackages (ps:
    #   with ps; [
    #     jupyter
    #     jupyter_core
    #     notebook
    #     ipython
    #     ipykernel
    #     pandas
    #     numpy
    #     systemd
    #     click
    #     jinja2
    #     clickhouse-driver
    #     flask
    #     autopep8
    #     pip
    #     pyyaml
    #     pytz
    #     websockets
    #     black
    #     beancount
    #     PyGithub
    #     paramiko
    #     xmltodict
    #     lark
    #     openpyxl
    #     xlrd
    #     requests
    #   ]))
    # gparted
    # jq
    # ntp
    # graphviz
    # wget
    # vim
    cmake
    # python
    # neovim
    # git
    gdb
    # docker
    # ibus
    # fcitx5
    # graphviz
    # dpkg
    nixfmt
    # tree
    # ncdu
    # ripgrep
    # libev
    # linuxPackages.cpupower
    # dmidecode
    # black
    cpu-x
    # unrar
    # p7zip
    # rclone
    # rsync
    # parted
    # ethtool
    # iperf
    # nvme-cli
    # smartmontools
    # cifs-utils
    glances
    htop
    home-manager
    translate-shell
  ];

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    cudaCapabilities = [ "7.5" "8.6" ];
    cudaForwardCompat = true;
    permittedInsecurePackages = [
      # *Exceptionally*, those packages will be cached with their *secure* dependents
      # because they will reach EOL in the middle of the 23.05 release
      # and it will be too much painful for our users to recompile them
      # for no real reason.
      # Remove them for 23.11.
      "nodejs-16.20.2"
      "openssl-1.1.1u"
      "openssl-1.1.1v"
      "openssl-1.1.1w"
      "python2.7-pyjwt-1.7.1"
      "python-2.7.18.6"
      "python-2.7.18.8"
      "python2.7-certifi-2021.10.8"
    ];
  };

}
