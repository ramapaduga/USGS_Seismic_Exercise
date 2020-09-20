import requests
import sys
import os
import json
import snowflake.connector
import configparser
from configparser import ConfigParser
from datetime import datetime
from dateutil.relativedelta import *

config: ConfigParser = configparser.ConfigParser()
config.read(".pythonconfig") # UPDATE THE PYTHON CONFIG FILE WITH ETL CREDENTIALS
v_username = config.get('ETL_LOAD_CREDENTIALS', "LOADUSERNAME")
v_pass = config.get('ETL_LOAD_CREDENTIALS', "LOADPW")

class EarthquakeCatalog:

    def __init__(self, *args, **kwargs):
        self.startdate = kwargs.get('startdate', '')
        self.enddate = kwargs.get('enddate', '')
        self.outputfilename = kwargs.get('outputfilename', '')
        self.tablename="EXTRACT_USGS_CATALOG"
        self.cs=None
        self.user=v_username
        self.password=v_pass
        self.account='snowflakeaccountname' # UPDATE SNOWFLAKE ACCOUNT NAME
        self.url='snowflakeaccountname.snowflakecomputing.com' # UPDATE SNOWFLAKE ACCOUNT URL
        self.role=''
        self.schema='public'
        self.warehouse='WAREHOUSE_SIZE'
        self.ctx=None

    ######### DELETE THE FILE FILE IF EXISTS
    def removefile(self):
        try:
            os.remove(self.outputfilename)
        except OSError:
            pass

    ######### GET THE SEISMIC DATA FROM THE PROVIDED API
    def GetUSGSData(self):
        try:
            self.removefile()

            start = datetime.strptime(self.startdate, "%Y-%m-%d").date()
            # print("Input Start Date " + str(start))
            stop = datetime.strptime(self.enddate, "%Y-%m-%d").date()
            # print("Input End Date " + str(stop))

            while start < stop:
                stopdate = start + relativedelta(months=1)
                self.getsfconnection()
                print("Requesting data from USGS ...")
                usgsdatareq = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime={}&endtime={}".format(start, stopdate)
                print(usgsdatareq)
                print("Extracting data from USGS ...")
                usgsdata = requests.get(usgsdatareq).json()
                print("Writing data to " + self.outputfilename)
                with open(self.outputfilename, 'a', encoding='utf-8') as outfile:
                    json.dump(usgsdata, outfile)
                print("Completed extracting data!")
                print("Copying USGS data to Snowflake ...")
                self.copy_tosnowflake()
                print("Completed USGS data to Snowflake!")
                start = start + relativedelta(months=1)  # increase by 1 month due to record limitation of the API

        finally:
            self.cs.close()
            self.ctx.close()

    #########  CREATE CONNECTION TO SNOWFLAKE
    def getsfconnection(self):
        print("CREATING SNOWFLAKE CONNECTION ---->")
        ctx = snowflake.connector.connect(
            user=self.user,
            password=self.password,
            account=self.account,
            url=self.url,
            role=self.role,
            schema=self.schema,
            warehouse=self.warehouse
        )
        cs = ctx.cursor()
        print("Snowflake Connection created")
        self.cs= cs
        self.ctx=ctx

    ######### LOAD DATA INTO SNOWFLAKE DATABASE TABLE
    def copy_tosnowflake(self):
        s_query = "USE ADHOC_DB.PUBLIC"
        self.cs.execute(s_query)
        putfile_query = "put file://USGS.json @MY_INT_STAGE"
        self.cs.execute(putfile_query)
        # trunc_query = "truncate table {}".format(self.tablename)
        # self.cs.execute(trunc_query)
        copy_query = "copy into {} from '@MY_INT_STAGE/{}' file_format = (type = json);".format(self.tablename, self.outputfilename)
        self.cs.execute(copy_query)

def main(**kwargs):
    usgs = EarthquakeCatalog(**kwargs)
    usgs.GetUSGSData()


if __name__ == '__main__':
    jobargs=None
    print (sys.argv)
    if len(sys.argv) >1:
        jobargs={}
        for arg in sys.argv[1:]:
            args=arg.split('=')
            jobargs[args[0]]=args[1]

        print(jobargs)

    if jobargs is None:
        main()
    else:
        main(**jobargs)


