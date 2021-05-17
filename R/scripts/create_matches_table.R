
setwd( "/Users/harry/rugby_data_project_airflow")

args <- commandArgs(trailingOnly = TRUE)

link <- args[1]




source("R/variables/data_variables.R")
source("R/functions/create_links_table_functions.R")
library(tidyverse)
library(lubridate)
library(rvest)

 date <- format(Sys.Date(), "%Y%m%d")
exc_date <- args[2] 



exc_date <- exc_date

print(exc_date)

matches <- file.path(formatted_area, "matches")

if (!dir.exists(matches)){
  dir.create(matches)
}

date_file <- file.path(matches, exc_date)

if (!dir.exists(date_file)){
  dir.create(date_file)
}



  
  comp_name <- str_extract_all(link,"(?<=com/)[a-z0-9-]+") %>%
    str_replace_all("-", "_") 
  
  print(paste("Getting", comp_name, "links"))

  links <- get_rugby_pass_links(link)



  table <- create_links_table(link, links) 
  
  # Only get historical matches 
  table <- table %>% 
    filter(date < exc_date)
  
  csv_file <- file.path(date_file, paste(comp_name, ".csv", sep = ""))
  
if(file.exists( csv_file )){
  read_csv(csv_file,
           col_types = cols(season = "c")) %>% 
    bind_rows(table) %>% 
    distinct(rugby_pass_url, .keep_all = TRUE) %>% 
    write_csv(csv_file)
} else {
 table %>% 
      write_csv(csv_file)
}

  print(paste(comp_name, "saved"))




