from setuptools import setup, find_packages

setup(
    name="usgs-seismic_data",
    description="Git pull from master branch",
    version="0.0.1",
    packages=find_packages(),
    package_data={['dag_api_jobs/cost_reportjob/*.json','dag_api_jobs/cost_reportjob/*.dat','dag_api_jobs/GoogleDoubleClick/*.json','dag_api_jobs/GoogleDoubleClick/*.dat','dag_api_jobs/GoogleDoubleClick/*.txt']},
    author="Ramanathan Ramadurai",
    author_email="ramapaduga@gmail.com",
    url="https://github.com/ramapaduga/USGS_Seismic_Exercise"

)