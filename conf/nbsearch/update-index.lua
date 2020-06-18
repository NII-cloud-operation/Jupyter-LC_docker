update_index = {
	maxProcesses = 1,
	delay = 1,
	onCreate  = "/opt/nbsearch/update-index ^pathname",
	onModify  = "/opt/nbsearch/update-index ^pathname",
	onMove    = "/opt/nbsearch/update-index ^d.pathname",
}

settings {
  logfile    = "/tmp/lsyncd.log",
  statusFile = "/tmp/lsyncd.status",
  nodaemon   = false,
}

sync{update_index, source=os.getenv("NBSEARCHDB_BASE_DIR") or ("/home/" .. os.getenv("NB_USER"))}
