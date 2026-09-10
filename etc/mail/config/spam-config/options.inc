task_timeout = 25s;
dns {
  nameserver = ["unbound"];
  timeout = 5s;
  retransmits = 5;
  sockets = 128;
}
