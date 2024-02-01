SERVER := htwserver-mk
APPDIR := ~/ShinyApps/learnrextra_testapp_shiny
SERVER_APP := $(SERVER):$(APPDIR)
RSYNC_COMMON := -rcv --exclude-from=.rsyncexclude

devserver:
	R -e 'renv::install("../learnrextra");shiny::runApp(port = 8002, launch.browser = FALSE)'

sync: deploymentfiles
	rsync $(RSYNC_COMMON) . $(SERVER_APP)
	ssh $(SERVER) 'cd $(APPDIR) && mv app_prod.R app.R'
	rm app_prod.R

testsync: deploymentfiles
	rsync $(RSYNC_COMMON) -n . $(SERVER_APP)
	rm app_prod.R

reload:
	ssh $(SERVER) 'touch $(APPDIR)/restart.txt'

installdeps:
	ssh $(SERVER) 'cd $(APPDIR) && R -e "renv::restore()"'

deploymentfiles:
	sed -- 's/http:\/\/localhost:8000/https:\/\/rshiny.f4.htw-berlin.de\/api/g' app.R > app_prod.R
