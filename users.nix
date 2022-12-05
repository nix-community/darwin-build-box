let
  # To add yourself:
  # 1. Add an entry to this list, using the next UID.
  # 2. Create a file in `keys` named your user name that contains your SSH key(s), separated by newlines.
  users = [
    {
      name = "winter";
      trusted = true;
      uid = 502;
    }
    {
      name = "stephank";
      trusted = true;
      uid = 503;
    }
    {
      name = "hexa";
      trusted = true;
      uid = 504;
    }
  ];
in
{
  users.users = builtins.listToAttrs (builtins.map
    (u: {
      inherit (u) name;
      value = {
        inherit (u) uid;
        home = "/Users/${u.name}";
        createHome = true;
        shell = "/bin/zsh";
      };
    })
    users);

  users.knownUsers = builtins.map (u: u.name) users;

  users.forceRecreate = true;

  environment.etc = builtins.listToAttrs (builtins.map
    (u: {
      name = "ssh/authorized_keys.d/${u.name}";
      value = { source = ./keys/${u.name}; };
    })
    users);

  nix.settings.trusted-users = builtins.map (u: u.name) (builtins.filter (u: u.trusted) users);
}
