# usgs-seismic-data
1. Python Job to download usgs seismic data from USGS API
2. This is a working solution to fetch data from USGS API and dump that data into a json file
3. Push that json into snowflake database using snowflake python connector
4. Folder contains the Python script to pull data from USGS API, DDL's, Analysis queries, analysis output and images

EXAMPLE USAGE
## USGS Seismic data to fetch full 2017 data
``` python EarthquakeCatalog_V2.py startdate="2017-01-01" enddate="2018-01-01" outputfilename='USGS.json'```

# REQUIRMENTS BEFORE PROCESSING THE DATA
1. Snowflake account or may be 30 day trial account https://signup.snowflake.com/
2. Have .pythonconfig file in the current directory as below for snowflake credentials<br/>
   ETL_LOAD_CREDENTIALS]<br/>
   LOADUSERNAME=LOAD_USER_NAME<br/>
   LOADPW=LOAD_PW
3. Python version > 3.6
4. Install necessary modules or packages to execute the python code
