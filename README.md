# NYC Taxi Dataset Oozie

Download the NYC Taxi dataset to HDFS using Oozie.

## Setup

```sh
hdfs dfs -mkdir -p /user/oozie/nyc-taxi-wf
```

## Test Coordinator on HDP Sandbox

```sh
export OOZIE_URL=http://sandbox.hortonworks.com:11000/oozie

hdfs dfs -put -f nyc-taxi-wf /user/oozie
oozie job -config nyc-taxi-wf/job.properties -run
```

## Test Coordinator on HDInsight

```sh
export OOZIE_URL=http://headnodehost:11000/oozie
export JOB_TRACKER=headnodehost:8050
export NAME_NODE=adl://home

hdfs dfs -put -f nyc-taxi-wf /user/oozie
oozie job -config nyc-taxi-wf/job.properties -D jobTracker=$JOB_TRACKER -D nameNode=$NAME_NODE -run
```

### Run all

```sh
hdfs dfs -put -f nyc-taxi-wf /user/oozie

make
```

## License

This software is provided under MIT license.
