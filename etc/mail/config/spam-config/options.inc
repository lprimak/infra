dns {
  nameserver = ["unbound"];
  timeout = 30s;
  sockets = 128;
}
