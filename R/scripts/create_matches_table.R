
setwd( "/Users/harry/rugby_data_project_airflow")

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
                      "https://www.rugbypass.com/premiership/matches/",
                      "https://www.rugbypass.com/six-nations/matches/",
                      "https://www.rugbypass.com/the-rugby-championship/matches/",
                      "https://www.rugbypass.com/internationals/matches/2019/",
                      "https://www.rugbypass.com/internationals/matches/2020/",
                      "https://www.rugbypass.com/premiership-cup/matches/",
                      "https://www.rugbypass.com/european-champions-cup/matches/",
                      "https://www.rugbypass.com/challenge-cup/matches/2019-2020/",
                     "https://www.rugbypass.com/pro-14/matches/",
                     "https://www.rugbypass.com/pro-14-rainbow-cup/matches/",
                     "https://www.rugbypass.com/rainbow-cup-south-africa/matches/",
                    "https://www.rugbypass.com/super-rugby-trans-tasman/matches/",
                    "https://www.rugbypass.com/super-rugby-australia/matches/",
                    "https://www.rugbypass.com/super-rugby-unlocked/matches/",
                    "https://www.rugbypass.com/super-rugby/matches/",
                    "https://www.rugbypass.com/mitre-10-cup/matches/",
                    "https://www.rugbypass.com/currie-cup/matches/",
                    "https://www.rugbypass.com/rugby-world-cup/matches/",
                    "https://www.rugbypass.com/top-14/matches/"
                    )


for (tournement_link in tournement_links){
  
  comp_name <- str_extract_all(tournement_link,"(?<=com/)[a-z0-9-]+") %>%
    str_replace_all("-", "_") 
  
  print(paste("Getting", comp_name, "links"))

  links <- get_rugby_pass_links(tournement_link)



  table <- create_links_table(tournement_link, links) 
  
  # Only get historical matches 
  table <- table %>% 
    filter(date < Sys.Date())
  
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

}


