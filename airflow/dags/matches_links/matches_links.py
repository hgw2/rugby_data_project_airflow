import datetime as dt

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.latest_only import LatestOnlyOperator
import rpy2.robjects as robjects



default_args = {
    "owner": "me",
    "start_date": dt.datetime(2021, 5, 16),
    "retries": 1,
    "retry_delay": dt.timedelta(seconds=15),
}

links = {"autumn_nations_cup":" https://www.rugbypass.com/autumn-nations-cup/matches/"}


with DAG(
    "matches_links", default_args=default_args, schedule_interval="0 10 * * *"
) as dag:
    
    latest_only = LatestOnlyOperator(task_id="latest_only")
    
    for comp, link in links.items():
         get_rugby_pass_match_data = BashOperator(
        task_id=f"get_{comp}_links", bash_command=f"Rscript /Users/harry/rugby_data_project_airflow/R/scripts/create_matches_table.R {link}",
    )

   
    
    latest_only >> get_rugby_pass_match_data
