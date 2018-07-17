all: taxi-yellow taxi-green taxi-fhv

WF_DIR := nyc-taxi-wf

OOZIE_HOST := sandbox.hortonworks.com
OOZIE_PORT := 11000
OOZIE_HTTP := http

taxi-yellow:
	oozie job -oozie $(OOZIE_HTTP)://$(OOZIE_HOST):$(OOZIE_PORT)/oozie \
		-config $(WF_DIR)/job.properties \
		-D taxiSlug=yellow \
		-D coordStart=2009-01-01T00:00Z \
		-D coordEnd=2017-12-31T00:00Z \
		-run

taxi-green:
	oozie job -oozie $(OOZIE_HTTP)://$(OOZIE_HOST):$(OOZIE_PORT)/oozie \
		-config $(WF_DIR)/job.properties \
		-D taxiSlug=green \
		-D coordStart=2013-08-01T00:00Z \
		-D coordEnd=2017-12-31T00:00Z \
		-run

taxi-fhv:
	oozie job -oozie $(OOZIE_HTTP)://$(OOZIE_HOST):$(OOZIE_PORT)/oozie \
		-config $(WF_DIR)/job.properties \
		-D taxiSlug=fhv \
		-D coordStart=2015-01-01T00:00Z \
		-D coordEnd=2017-12-31T00:00Z \
		-run