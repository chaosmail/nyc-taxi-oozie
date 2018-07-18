# NYC Taxi Dataset Oozie

Download the NYC Taxi dataset to HDFS using Oozie.

## Setup

```sh
hdfs dfs -mkdir -p /user/oozie/nyc-taxi-wf
```

## Test Coordinator

```sh
hdfs dfs -put -f nyc-taxi-wf /user/oozie

oozie job -oozie http://<oozie-server>:11000/oozie -config nyc-taxi-wf/job.properties -run
```

### Run all

```sh
hdfs dfs -put -f nyc-taxi-wf /user/oozie

make
```

## License

This software is provided under MIT license.
