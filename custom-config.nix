# This is mainly overriden in forks of this repository in order to set work
# related changes.
{
  # Overrides the work email
  workEmail = "peter.hansson17@gmail.com";

  # Use gh cli to authenticate to https://github.com
  ghCliAuthLogin = false;

  # A module used for all nixos configurations
  # Some useful examples used previously in the past:
  #
  # Use static name servers
  # module = (_: {
  #   environment.etc = {
  #     "resolv.conf".text = ''
  #       nameserver 3.3.3.3
  #       nameserver 8.8.8.8
  #     '';
  #   };
  # });
  # Use custom ntp servers
  # module = (_: {
  #   services.timesyncd = {
  #     enable = true;
  #     servers = [ "my.custom.ntp-server.com" "se.pool.ntp.org" ];
  #   };
  # });
  module = (_: {
  });
}
