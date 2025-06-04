{
  sshUser = "seungwon";
  user = "root";

  sshOpts = [
    "-o"
    "UserKnownHostsFile=/dev/null"
    "-o"
    "StrictHostKeyChecking=no"
    "-o"
    "ConnectTimeout=10"
    "-o"
    "ServerAliveInterval=60"
    "-o"
    "ServerAliveCountMax=3"
  ];

  autoRollback = true;
  magicRollback = true;

  activationTimeout = 300;
  confirmTimeout = 30;

  fastConnection = false;
  remoteBuild = true;
}
