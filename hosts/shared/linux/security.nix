{
  security.sudo.extraRules = [
    {
      users = [ "seungwon" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
