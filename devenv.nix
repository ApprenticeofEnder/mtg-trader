{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  env = {
    GREETING = "Welcome to the mtg-trader devenv!";
  };

  # https://devenv.sh/packages/
  packages = with pkgs; [git];

  # https://devenv.sh/languages/
  languages = {
    rust.enable = true;
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
    build = {
      exec = ''
        cargo build
      '';
    };
  };

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version
    rustc --version
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
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
