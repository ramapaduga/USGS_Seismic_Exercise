-- FLATTEN JSON DATA AND LOAD FEATURES DATA INTO A FACT TABLE

INSERT INTO FCT_USGS_CATALOG
SELECT DISTINCT B.VALUE:id :: VARCHAR AS FEATUREID
, B.VALUE:properties.mag :: NUMBER(10,3) AS MAG
, B.VALUE:properties.place :: VARCHAR AS PLACE
, DATEADD(MS, B.VALUE:properties.time :: BIGINT, '1970-01-01') AS TIME
, DATEADD(MS, B.VALUE:properties.updated :: BIGINT, '1970-01-01') AS UPDATED
, B.VALUE:properties.tz :: INTEGER AS TZ
, B.VALUE:properties.url :: VARCHAR AS URL
, B.VALUE:properties.detail :: VARCHAR AS DETAIL
, B.VALUE:properties.felt :: INTEGER AS FELT
, B.VALUE:properties.cdi :: NUMBER(38,20) AS CDI
, B.VALUE:properties.mmi :: NUMBER(38,10) AS MMI
, B.VALUE:properties.alert :: VARCHAR AS ALERT
, B.VALUE:properties.status :: VARCHAR AS STATUS
, B.VALUE:properties.tsunami :: INTEGER AS TSUNAMI
, B.VALUE:properties.sig :: INTEGER AS SIG
, B.VALUE:properties.net :: VARCHAR AS NET
, B.VALUE:properties.code :: VARCHAR AS CODE
, B.VALUE:properties.ids :: VARCHAR AS IDS
, B.VALUE:properties.sources :: VARCHAR AS SOURCES
, B.VALUE:properties.types :: VARCHAR AS TYPES
, B.VALUE:properties.nst :: INTEGER AS NST
, B.VALUE:properties.dmin :: NUMBER(10,3) AS DMIN
, B.VALUE:properties.rms :: NUMBER(10,3) AS RMS
, B.VALUE:properties.gap :: NUMBER(10,3) AS GAP
, B.VALUE:properties.magType :: VARCHAR AS MAG_TYPE
, B.VALUE:properties.type :: VARCHAR AS TYPE
, B.VALUE:properties.title :: VARCHAR AS TITLE
, CURRENT_DATE AS ETL_LOAD_DATE
FROM EXTRACT_USGS_CATALOG A
, TABLE(FLATTEN(INPUT => SEISMIC_DATA, path => 'features')) B;

-- FLATTEN JSON DATA AND LOAD GEOMETRY DATA INTO A DIMENSION TABLE

INSERT INTO DM_USGS_GEOMETRY
SELECT DISTINCT B.VALUE:id :: VARCHAR AS FEATUREID
, B.VALUE:geometry.type :: VARCHAR AS GEOMETRY_TYPE
, B.VALUE:geometry.coordinates :: VARIANT AS COORDINATES
FROM EXTRACT_USGS_CATALOG A
, TABLE(FLATTEN(INPUT => SEISMIC_DATA, path => 'features')) B;

-- 5) Provide query/analysis to give biggest earthquake of 2017

SELECT A.*
FROM FCT_USGS_CATALOG A
JOIN (SELECT MAX(MAG) AS MAX_MAG FROM FCT_USGS_CATALOG WHERE TYPE = 'earthquake') B
ON A.MAG = MAX_MAG
WHERE A.TYPE = 'earthquake';

-- 6) Provide query/analysis to give most probable hour of the day for the earthquakes bucketed by the range of magnitude (0-1,1-2,2-3,3-4,4-5,5-6,>6   
-- For border values in the bucket, include them in the bucket where the value is a lower limit so for 1 include it in 1-2 bucket)

SELECT HOUR(TIME) AS HOUR
, CASE WHEN ROUND(MAG, 0) BETWEEN 0 AND 1 THEN '0-1'
       WHEN ROUND(MAG, 0) BETWEEN 1 AND 2 THEN '1-2'
       WHEN ROUND(MAG, 0) BETWEEN 2 AND 3 THEN '2-3'
       WHEN ROUND(MAG, 0) BETWEEN 4 AND 5 THEN '4-5'
       WHEN ROUND(MAG, 0) BETWEEN 5 AND 6 THEN '5-6'
       WHEN ROUND(MAG, 0) > 6 THEN '>6'
  ELSE '>6'
  END AS MAGNITUDE_RANGE
, COUNT(*) AS NUMBER_OF_EVENTS
FROM FCT_USGS_CATALOG
WHERE TYPE = 'earthquake'
GROUP BY 1, 2
ORDER BY 3 DESC;

-- TOP 10 HIGH SIGNIFICANT EVENTS TRIGGERED IN OCEANIC REGIONS OR TSUNAMI MAY BE HAPPENED

SELECT A.*
FROM FCT_USGS_CATALOG A
JOIN (SELECT SIG FROM FCT_USGS_CATALOG WHERE TSUNAMI = 1 ORDER BY 1 DESC LIMIT 10) B
ON A.SIG = B.SIG
WHERE TSUNAMI = 1;

-- TOP 10 REGIONS WITH MOST EVENTS

SELECT TRIM(SUBSTR(PLACE, regexp_instr(PLACE, ',') + 1, LENGTH(PLACE))) AS REGION
, COUNT(*) AS TOTAL_EVENTS
FROM FCT_USGS_CATALOG
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
