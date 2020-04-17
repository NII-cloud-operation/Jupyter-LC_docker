update_index = {
	maxProcesses = 1,
	delay = 1,
	onCreate  = "/opt/nbsearch/update-index ^pathname",
	onModify  = "/opt/nbsearch/update-index ^pathname",
	onMove    = "/opt/nbsearch/update-index ^d.pathname",
}

sync{update_index, source="/home/" .. os.getenv("USER")}
