import rpy2.robjects as robjects

r = robjects.r
r['source']("/Users/harry/rugby_data_project_airflow/R/scripts/create_matches_table.R")
