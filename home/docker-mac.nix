{ pkgs, ... }:

let
  # nixpkgs 25.05 is still on docker-compose 2.36.0
  # I need the initial_sync feature which appeared on 2.39.4
  docker-compose = pkgs.docker-compose.overrideAttrs (old: rec {
    version = "2.39.4";
    src = pkgs.fetchFromGitHub {
      owner = "docker";
      repo = "compose";
      rev = "v${version}";
      hash = "sha256-NDNyXK4E7TkviESHLp8M+OI56ME0Hatoi9eWjX+G1zo=";
    };
    vendorHash = "sha256-Uqzul9BiXHAJ1BxlOtRS68Tg71SDva6kg3tv7c6ar2E=";
    ldflags = [
      "-X github.com/docker/compose/v2/internal.Version=${version}"
      "-s"
      "-w"
    ];
  });
  # after overriding the compose plugin, it needs to be given to docker itself
  docker = pkgs.docker_28.override {
    docker-compose = docker-compose;
  };
  colima = pkgs.colima;
in {
  home.packages = [
    docker
    colima
  ];

  launchd.agents = {
    colima = {
      enable = true;
      config = {
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ExitTimeOut = 10;
        # colima refuses to start if it doesn't find the docker exec
        EnvironmentVariables = {
          PATH = "${colima}/bin:${docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        # changes the process between background and interactive depending on its usage (in theory)
        ProcessType = "Adaptive";
        ProgramArguments = [
          "${colima}/bin/colima"
          "start"
          "--foreground"
          "--ssh-agent"
        ];
        StandardErrorPath = "/tmp/colima-logs/stderr.log";
        StandardOutPath = "/tmp/colima-logs/stdout.log";
        # start on login
        RunAtLoad = true;
      };
    };
  };
}
