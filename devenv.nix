{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  projectName = "mtg-trader";
  template = "svelte"; # used during tauri init
  manifestPath = "${config.git.root}/${projectName}/src-tauri/Cargo.toml";
  libraries = with pkgs; [
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib.out
    dbus.lib

    # added this for https://github.com/tauri-apps/tauri/issues/4930
    libthai
  ];
  joinLibs = libs: builtins.concatStringsSep ":" (builtins.map (x: "${x}/lib") libs);
  libs = joinLibs libraries;
in {
  env = {
    GREETING = "Welcome to the ${projectName} devenv!";
    TEMPLATE = template;
  };

  overlays = [
    inputs.nixgl.overlays.default
  ];

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    xapp
    gtk3
    glib
    dbus
    pango
    librsvg
    openssl
    libsoup_3
    pkg-config
    webkitgtk_4_1

    atkmm
    harfbuzz
    at-spi2-atk
    nixgl.auto.nixGLDefault
  ];

  # https://devenv.sh/languages/
  languages = {
    rust.enable = true;
    javascript = {
      enable = true;
      bun = {
        enable = true;
        install.enable = true;
      };
    };
    typescript.enable = true;
  };

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    hello = {
      exec = "echo ${config.env.GREETING}";
    };
    # build = {
    #   exec = ''
    #     cargo build
    #   '';
    # };
    tauri-info = {
      exec = "bun run tauri info";
    };
    run = {
      exec = ''
        cd ${config.git.root}/${projectName}
        bun run tauri dev
      '';
    };
  };

  enterShell = ''
    export LD_LIBRARY_PATH=${libs}:$LD_LIBRARY_PATH
    hello
    rustc --version
    echo "bun $(bun --version)"
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    clippy = {
      enable = true;
      settings.extraArgs = "--manifest-path ${manifestPath}";
    };
    rustfmt = {
      enable = true;
      settings.manifest-path = manifestPath;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
