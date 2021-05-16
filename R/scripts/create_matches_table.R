source("R/variables/data_variables.R")
source("R/functions/create_links_table_functions.R")
library(tidyverse)
library(lubridate)
library(rvest)

date <- format(Sys.Date(), "%Y%m%d")


matches <- file.path(formatted_area, "matches")

if (!dir.exists(matches)){
  dir.create(matches)
}

date_file <- file.path(matches, date)

if (!dir.exists(date_file)){
  dir.create(date_file)
}


tournement_links<-  c("https://www.rugbypass.com/autumn-nations-cup/matches/",
                      "https://www.rugbypass.com/premiership/matches/")


for (tournement_link in tournement_links){
  
  comp_name <- str_extract_all(tournement_link,"(?<=com/)[a-z0-9-]+") %>%
    str_replace_all("-", "_") 

  links <- get_rugby_pass_links(tournement_link)



  table <- create_links_table(tournement_link, links) 
  
  # Only get historical matches 
  table <- table %>% 
    filter(date < Sys.Date())
  
  csv_file <- file.path(date_file, paste(comp_name, ".csv", sep = ""))
  

 table %>% 
      write_csv(csv_file)



}


