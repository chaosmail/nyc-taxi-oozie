set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

set hivevar:TBL_NAME=nyc_taxi_trips_yellow;
set hivevar:TBL_LOCATION=adl://home/data/nyc-taxi-trips/yellow;
set hivevar:SRC_TBL_NAME=nyc_taxi_trips_yellow_raw;

CREATE TEMPORARY MACRO parse_ts(val STRING)
cast(unix_timestamp(val, 'yyyy-MM-dd HH:mm:ss') * 1000 as TIMESTAMP);

DROP TABLE IF EXISTS `${TBL_NAME}`;

CREATE TABLE IF NOT EXISTS `${TBL_NAME}` (
  vendor_name STRING COMMENT 'A code indicating the TPEP provider that provided the record. 1= Creative Mobile Technologies, LLC. 2= VeriFone Inc.',
  Trip_Pickup_DateTime TIMESTAMP COMMENT 'The date and time when the meter was engaged.',
  Trip_Dropoff_DateTime TIMESTAMP COMMENT 'The date and time when the meter was disengaged.',
  Passenger_Count INT COMMENT 'The number of passengers in the vehicle. This is a driver-entered value.',
  Trip_Distance DOUBLE COMMENT 'The elapsed trip distance in miles reported by the taximeter.',
  Start_Lon DOUBLE,
  Start_Lat DOUBLE,
  Rate_Code INT COMMENT 'The final rate code in effect at the end of the trip. 1= Standard rate 2=JFK 3=Newark 4=Nassau or Westchester 5=Negotiated fare 6=Group ride',
  Store_And_Forward STRING COMMENT 'This flag indicates whether the trip record was held in vehicle memory before sending to the vendor, aka “store and forward,” because the vehicle did not have a connection to the server.  Y= store and forward trip N= not a store and forward trip.',
  End_Lon DOUBLE,
  End_Lat DOUBLE,
  Payment_Type STRING COMMENT 'A numeric code signifying how the passenger paid for the trip.  1= Credit card 2= Cash 3= No charge 4= Dispute 5= Unknown 6= Voided trip.',
  Fare_Amt DOUBLE COMMENT 'The time-and-distance fare calculated by the meter.',
  Surcharge DOUBLE COMMENT 'Miscellaneous extras and surcharges.  Currently, this only includes the $0.50 and $1 rush hour and overnight charges.',
  Mta_Tax DOUBLE COMMENT '$0.50 MTA tax that is automatically triggered based on the metered rate in use.',
  Tip_Amt DOUBLE COMMENT 'Tip amount – This field is automatically populated for credit card tips. Cash tips are not included.',
  Tolls_Amt DOUBLE COMMENT 'Total amount of all tolls paid in trip.',
  Total_Amt DOUBLE COMMENT 'The total amount charged to passengers. Does not include cash tips.'
)

PARTITIONED BY (
  dt STRING COMMENT 'Year of Trip_Pickup_DateTime'
)

STORED AS ORC

LOCATION '${TBL_LOCATION}'

TBLPROPERTIES (
  'orc.compress'='SNAPPY',
  'orc.create.index'='true',
  'orc.bloom.filter.columns'='vendor_name',
  'orc.bloom.filter.fpp'='0.05'
)
;

INSERT INTO `${TBL_NAME}` PARTITION (dt)

SELECT
  vendor_name,
  parse_ts(Trip_Pickup_DateTime) as Trip_Pickup_DateTime,
  parse_ts(Trip_Dropoff_DateTime) as Trip_Dropoff_DateTime,
  Passenger_Count,
  Trip_Distance,
  Start_Lon,
  Start_Lat,
  Rate_Code,
  Store_And_Forward,
  End_Lon,
  End_Lat,
  Payment_Type,
  Fare_Amt,
  Surcharge,
  Mta_Tax,
  Tip_Amt,
  Tolls_Amt,
  Total_Amt,
  date_format(parse_ts(Trip_Pickup_DateTime), 'yyyy') as dt

FROM
  `${SRC_TBL_NAME}`

WHERE
  year(parse_ts(Trip_Pickup_DateTime)) BETWEEN 2009 AND 2017

DISTRIBUTE BY
  dt

SORT BY
  Trip_Pickup_DateTime ASC
;
