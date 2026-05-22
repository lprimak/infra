dns {
  nameserver = ["unbound", "10.0.1.210"];
  timeout = 30s;
  sockets = 128;
}
