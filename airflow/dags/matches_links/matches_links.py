import datetime as dt

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.latest_only import LatestOnlyOperator
from airflow.operators.postgres_operator import PostgresOperator


default_args = {
    "owner": "me",
    "start_date": dt.datetime(2021, 5, 16),
    "retries": 1,
    "retry_delay": dt.timedelta(seconds=15),
}

links = {
    "autumn_nations_cup": " https://www.rugbypass.com/autumn-nations-cup/matches/",
    "premiership": "https://www.rugbypass.com/premiership/matches/",
    "six_nations": "https://www.rugbypass.com/six-nations/matches/",
    "the_rugby_championship": "https://www.rugbypass.com/the-rugby-championship/matches/",
    "internations_2019": "https://www.rugbypass.com/internationals/matches/2019/",
    "internationals_2020": "https://www.rugbypass.com/internationals/matches/2020/",
    "premiership_cup": "https://www.rugbypass.com/premiership-cup/matches/",
    "european_champions_cup": "https://www.rugbypass.com/european-champions-cup/matches/",
    "challenge_cup": "https://www.rugbypass.com/challenge-cup/matches/2019-2020/",
    "pro_14": "https://www.rugbypass.com/pro-14/matches/",
    "pro_14_rainbow_cup": "https://www.rugbypass.com/pro-14-rainbow-cup/matches/",
    "south_africa_rainbow_cup": "https://www.rugbypass.com/rainbow-cup-south-africa/matches/",
    "super_rugby_trans": "https://www.rugbypass.com/super-rugby-trans-tasman/matches/",
    "super_rugby_aus": "https://www.rugbypass.com/super-rugby-australia/matches/",
    "super_rugby_unlocked": "https://www.rugbypass.com/super-rugby-unlocked/matches/",
    "super_rugby": "https://www.rugbypass.com/super-rugby/matches/",
    "mitre_10": "https://www.rugbypass.com/mitre-10-cup/matches/",
    "currie_cup": "https://www.rugbypass.com/currie-cup/matches/",
    "RWC": "https://www.rugbypass.com/rugby-world-cup/matches/",
    "top_14": "https://www.rugbypass.com/top-14/matches/",
}

execution_date = "{{ ds }}"

with DAG(
    "matches_links", default_args=default_args, schedule_interval="0 09 * * *"
) as dag:
    
    latest_only = LatestOnlyOperator(task_id="latest_only")
    

    for comp, link in links.items():
        get_rugby_pass_match_data = BashOperator(
            task_id=f"get_{comp}_links",
            bash_command=f"Rscript /Users/harry/rugby_data_project_airflow/R/scripts/create_matches_table.R {link} {execution_date}",
        )
        
        latest_only >> get_rugby_pass_match_data 
        
        sdfsdasd
