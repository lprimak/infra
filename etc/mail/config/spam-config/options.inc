dns {
  nameserver = ["unbound", "10.0.1.210", "1.1.1.1", "8.8.8.8"];
  timeout = 30s;
  sockets = 128;
}
