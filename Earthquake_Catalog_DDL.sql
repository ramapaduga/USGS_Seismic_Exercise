CREATE DATABASE USGS_ANALYTICS;

USE DATABASE USGS_ANALYTICS;

CREATE OR REPLACE TEMPORARY STAGE MY_INT_STAGE;

CREATE OR REPLACE TABLE EXTRACT_USGS_CATALOG
(
SEISMIC_DATA VARIANT
);

create or replace TABLE DM_USGS_GEOMETRY (
	FEATUREID VARCHAR(255),
	GEOMETRY_TYPE VARCHAR(255),
	COORDINATES VARIANT
);

CREATE OR REPLACE TABLE FCT_USGS_CATALOG
(
FEATUREID VARCHAR(255) COMMENT 'Unique identifier for a event occured',
MAG NUMBER(10,3) COMMENT 'The magnitude for the event',
PLACE VARCHAR COMMENT 'Textual description of named geographic region near to the event',
TIME TIMESTAMP COMMENT 'Time when the event occurred. Times are reported in milliseconds since the epoch ( 1970-01-01T00:00:00.000Z), and do not include leap seconds. In certain output formats, the date is formatted for readability.',
UPDATED TIMESTAMP COMMENT 'Time when the event was most recently updated. Times are reported in milliseconds since the epoch. In certain output formats, the date is formatted for readability.',
TZ INTEGER COMMENT 'Timezone offset from UTC in minutes at the event epicenter',
URL VARCHAR COMMENT 'Link to USGS Event Page for event.',
DETAIL VARCHAR COMMENT 'Link to GeoJSON detail feed from a GeoJSON summary feed.',
FELT INTEGER COMMENT 'The total number of felt reports submitted to the DYFI? system',
CDI NUMBER(38,10) COMMENT 'The maximum reported intensity for the event. Computed by DYFI. While typically reported as a roman numeral, for the purposes of this API, intensity is expected as the decimal equivalent of the roman numeral. Learn more about magnitude vs. intensity.',
MMI NUMBER(38,10) COMMENT 'The maximum estimated instrumental intensity for the event. Computed by ShakeMap. While typically reported as a roman numeral, for the purposes of this API, intensity is expected as the decimal equivalent of the roman numeral. Learn more about magnitude vs. intensity.',
ALERT VARCHAR COMMENT 'The alert level from the PAGER earthquake impact scale.',
STATUS VARCHAR(50) COMMENT 'Indicates whether the event has been reviewed by a human.',
TSUNAMI INTEGER COMMENT 'This flag is set to "1" for large events in oceanic regions and "0" otherwise. The existence or value of this flag does not indicate if a tsunami actually did or will exist',
SIG INTEGER COMMENT 'A number describing how significant the event is. Larger numbers indicate a more significant event. This value is determined on a number of factors, including: magnitude, maximum MMI, felt reports, and estimated impact.',
NET VARCHAR(50) COMMENT 'The ID of a data contributor. Identifies the network considered to be the preferred source of information for this event.',
CODE VARCHAR(255) COMMENT 'An identifying code assigned by - and unique from - the corresponding source for the event.',
IDS VARCHAR COMMENT 'A comma-separated list of event ids that are associated to an event.',
SOURCES VARCHAR(50) COMMENT 'A comma-separated list of network contributors.',
TYPES VARCHAR COMMENT 'A comma-separated list of product types associated to this event.',
NST INTEGER COMMENT 'The total number of seismic stations used to determine earthquake location.',
DMIN NUMBER(10,3) COMMENT 'Horizontal distance from the epicenter to the nearest station (in degrees). 1 degree is approximately 111.2 kilometers. In general, the smaller this number, the more reliable is the calculated depth of the earthquake.',
RMS NUMBER(10,3) COMMENT 'The root-mean-square (RMS) travel time residual, in sec, using all weights. This parameter provides a measure of the fit of the observed arrival times to the predicted arrival times for this location. Smaller numbers reflect a better fit of the data. The value is dependent on the accuracy of the velocity model used to compute the earthquake location, the quality weights assigned to the arrival time data, and the procedure used to locate the earthquake.',
GAP NUMBER(10,3) COMMENT 'The largest azimuthal gap between azimuthally adjacent stations (in degrees). In general, the smaller this number, the more reliable is the calculated horizontal position of the earthquake. Earthquake locations in which the azimuthal gap exceeds 180 degrees typically have large location and depth uncertainties.',
MAG_TYPE VARCHAR(50) COMMENT 'The method or algorithm used to calculate the preferred magnitude for the event.',
TYPE VARCHAR(50) COMMENT 'Type of seismic event.',
TITLE VARCHAR COMMENT 'Magnitude and place of this event marked as Title',
ETL_LOAD_DATE DATE COMMENT 'Data extracted date'
);

create or replace TABLE DM_DATE_ (
	DATE_KEY NUMBER(11,0),
	DATE_STAMP TIMESTAMP_NTZ(9),
	DAY_DESC VARCHAR(30),
	PREVIOUS_DAY_KEY NUMBER(11,0),
	MONTH_ID NUMBER(11,0),
	MONTH NUMBER(11,0),
	MONTH_DESC VARCHAR(30),
	DAY_OF_THE_MONTH NUMBER(11,0),
	QUARTER_ID NUMBER(11,0),
	QUARTER NUMBER(11,0),
	DAY_OF_THE_QUARTER NUMBER(11,0),
	YEAR NUMBER(11,0),
	DAY_OF_THE_YEAR NUMBER(11,0)
);

create or replace TABLE DM_MONTH (
	MONTH_ID NUMBER(38,0),
	QUARTER_ID NUMBER(38,0),
	MONTH NUMBER(38,0),
	MONTH_DESC VARCHAR(30),
	FIRST_DAY_OF_THE_MONTH TIMESTAMP_NTZ(9),
	LAST_DAY_OF_THE_MONTH TIMESTAMP_NTZ(9)
);

create or replace TABLE DM_QUARTER (
	QUARTER_ID NUMBER(38,0),
	QUARTER NUMBER(38,0),
	QTR_DESC VARCHAR(26),
	FIRST_DAY_OF_THE_QUARTER TIMESTAMP_NTZ(9),
	LAST_DAY_OF_THE_QUARTER TIMESTAMP_NTZ(9),
	YEAR NUMBER(38,0)
);

create or replace TABLE DM_YEAR (
	YEAR NUMBER(38,0),
	FIRST_DAY_OF_THE_YEAR TIMESTAMP_NTZ(9),
	LAST_DAY_OF_THE_YEAR TIMESTAMP_NTZ(9)
);