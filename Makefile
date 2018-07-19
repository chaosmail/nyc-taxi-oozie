all: fetch-taxi-yellow fetch-taxi-green fetch-taxi-fhv

WF_DIR := nyc-taxi-wf

OOZIE_HOST ?= sandbox.hortonworks.com
# OOZIE_HOST ?= headnodehost
OOZIE_PORT ?= 11000
OOZIE_HTTP ?= http

JOB_TRACKER ?= sandbox.hortonworks.com:8050
# JOB_TRACKER ?= headnodehost:8050
NAME_NODE ?= hdfs://sandbox.hortonworks.com:8020
# NAME_NODE ?= adl://home

fetch-taxi-yellow:
	oozie job -oozie $(OOZIE_HTTP)://$(OOZIE_HOST):$(OOZIE_PORT)/oozie \
		-config $(WF_DIR)/job.properties \
		-D jobTracker=$(JOB_TRACKER) \
		-D nameNode=$(NAME_NODE) \
		-D taxiSlug=yellow \
		-D coordStart=2009-01-01T00:00Z \
		-D coordEnd=2017-12-31T00:00Z \
		-run

fetch-taxi-green:
	oozie job -oozie $(OOZIE_HTTP)://$(OOZIE_HOST):$(OOZIE_PORT)/oozie \
		-config $(WF_DIR)/job.properties \
		-D jobTracker=$(JOB_TRACKER) \
		-D nameNode=$(NAME_NODE) \
		-D taxiSlug=green \
		-D coordStart=2013-08-01T00:00Z \
		-D coordEnd=2017-12-31T00:00Z \
		-run

fetch-taxi-fhv:
	oozie job -oozie $(OOZIE_HTTP)://$(OOZIE_HOST):$(OOZIE_PORT)/oozie \
		-config $(WF_DIR)/job.properties \
		-D jobTracker=$(JOB_TRACKER) \
		-D nameNode=$(NAME_NODE) \
		-D taxiSlug=fhv \
		-D coordStart=2015-01-01T00:00Z \
		-D coordEnd=2017-12-31T00:00Z \
		-run