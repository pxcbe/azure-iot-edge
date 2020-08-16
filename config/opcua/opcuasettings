{
  "Hostname": "publisher",
  "Cmd": [
    "publisher",
    "--pf=/appdata/publishednodes.json",
    "--di=60",
    "--to",
    "--aa",
    "--si=10",
    "--ms=262144"
  ],
  "HostConfig": {
    "Binds": [
      "/iiotedge:/appdata"
    ],
    "PortBindings": {
      "62222/tcp": [
        {
          "HostPort": "62222"
        }
      ]
    },
    "ExtraHosts": [
      "localhost:127.0.0.1"
    ]
  }
}
