import datetime as dt

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.latest_only import LatestOnlyOperator
import rpy2.robjects as robjects


def run_r(file):
    r.clear()
    r = robjects.r
    r["source"](file)


default_args = {
    "owner": "me",
    "start_date": dt.datetime(2021, 5, 16),
    "retries": 1,
    "retry_delay": dt.timedelta(seconds=15),
}


with DAG(
    "matches_links", default_args=default_args, schedule_interval="0 10 * * *"
) as dag:
    
    latest_only = LatestOnlyOperator(task_id="latest_only")

    get_rugby_pass_match_data = BashOperator(
        task_id="get_rugby_pass_match_data", bash_command="Rscript /Users/harry/rugby_data_project_airflow/R/scripts/create_matches_table.R",
    )
    
    latest_only >> get_rugby_pass_match_data
