{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  projectName = "mtg-trader";
  template = "svelte";
  manifestPath = "${config.git.root}/${projectName}/src-tauri/Cargo.toml";
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
    webkitgtk_4_1
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
    run = {
      exec = ''
        nixGL bun run tauri dev
      '';
    };
  };

  enterShell = ''
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
