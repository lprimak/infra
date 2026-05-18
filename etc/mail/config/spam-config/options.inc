dns {
  nameserver = ["unbound"];
  timeout = 5s;
  sockets = 128;
}
