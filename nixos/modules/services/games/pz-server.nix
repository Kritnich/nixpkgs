{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pz-server;
in {

  options.services.pz-server = {

    enable = mkEnableOption "Project Zomboid server";

    package = mkOption {
      type = types.package;
      default = pkgs.pz-server;
      example = literalExpression "pkgs.pz-server";
      description = ''
        Project Zomboid server package to use.
      '';
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/Zomboid";
      description = ''
        Server state directory.
      '';
    };

    adminPasswordFile = mkOption {
      type = types.path;
      default = null;
      example = literalExpression "/var/secrets/pzserver_pw";
      description = ''
        Path to admin password in a file.
      '';
    };

    openFirewall = mkEnableOption "opening the firewall ports for Project Zomboid";

    jvmOpts = mkOption {
      type = types.listOf types.str;
      default = [
        "-Xms2g"
        "-Xmx2g"
      ];
      description = ''
        Populate the JAVA_TOOL_OPTIONS environment variable.
      '';
    };
  };

  config = mkIf cfg.enable {

    systemd.services.pz-server = {
      description = "Project Zomboid server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/pz-server -cachedir=${cfg.stateDir} -adminpassword $(cat ${cfg.adminPasswordFile})";
        User = "pzserver";
        Restart = "always";
        WorkingDirectory = cfg.stateDir;
      };
      environment = {
        JAVA_TOOL_OPTIONS = builtins.concatStringsSep " " cfg.jvmOpts;
      };
    };

    users.users.pzserver = {
      isSystemUser = true;
      group = "pzserver";
      home = cfg.stateDir;
      createHome = true;
      description = "Project Zomboid server user";
    };
    users.groups.pzserver = {};

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ 8766 16261 ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ kritnich ];
  };
}
