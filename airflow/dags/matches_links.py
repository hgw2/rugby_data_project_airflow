import datetime as dt

from airflow import DAG
from airflow.operators.python import PythonOperator
import rpy2.robjects as robjects


def run_r(file_path):
    r = robjects.r
    r['source'](file_path)




default_args = {
    'owner': 'me',
    'start_date': dt.datetime(2017, 6, 1),
    'retries': 1,
    'retry_delay': dt.timedelta(minutes=5),
}


with DAG('matches_links',
         default_args=default_args,
         schedule_interval="@daily"
         ) as dag:

    
    get_rugby_pass_match_data = PythonOperator(task_id='get_rugby_pass_match_data',
                                 python_callable=run_r,
                                 op_kwargs= "Users/harry/rugby_data_project_airflow/R/scripts/create_matches_table.R")



