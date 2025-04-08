# {pkgs, ...}: {
#   services.mysql.package = pkgs.mariadb;
#
#   services.mysqlBackup = {
#     enable = true;
#     startAt = "*-*-* 02:00:00";
#     location = "/srv/backup/postgresql";
#   };
# }
{}
