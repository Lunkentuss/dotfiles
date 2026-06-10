# This is mainly overriden in forks of this repository in order to set work
# related changes.
{
  # Overrides the work email
  workEmail = "peter.hansson17@gmail.com";

  # Use gh cli to authenticate to https://github.com
  ghCliAuthLogin = true;

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
  module = (_: {
  });
}
