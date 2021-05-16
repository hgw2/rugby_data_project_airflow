source("R/functions/basic_functions.R")

create_links_table <- function(tournement_link, links){
  
  comp_name <- str_extract_all(tournement_link,"(?<=com/)[a-z0-9-]+") %>%
    str_replace_all("-", "_") 

  match <- str_extract(links, "[a-z0-9-]+[0-9]{8}") %>%
    str_extract("[a-z0-9-]+(?=-at)")%>% 
    str_replace_all("-", "_")
  
  date <- str_extract(links, "[0-9]{8}") %>% 
     dmy() 
  
  
  competition <- str_extract_all(links,"(?<=live/)[a-z0-9-]+") %>% 
    str_replace_all("-", "_")
  
  season <-  str_extract(links,"(?<=on-)[0-9]+/[0-9-]+") %>% 
    str_remove_all("[0-9]+/")
  
  venue <- str_extract(links, "(?<=at-)[a-z0-9-]+") %>% 
    str_remove_all("-on-[0-9]*") %>% 
    str_replace_all("-", "_")
  
  competition_type <- get_club_or_international(competition)
  
  rugby_pass_url <- links
  
  
  
  table <- tibble(match,
                  date,
                  venue,
                  competition,
                  comp_name,
                  season,
                  competition_type,
                  rugby_pass_url)
  
  
  
  table <- table %>%
    distinct(rugby_pass_url, .keep_all = TRUE) %>% 
    filter(str_detect(comp_name, competition)) %>% 
    select(-comp_name)


  return(table)
  
}

get_rugby_pass_links <- function(webpage){
  
  webpages <- read_html(webpage)
  
  links <- webpages %>% 
    html_nodes("a") %>% 
    html_attr("href") %>% 
    str_extract_all( "https://www.rugbypass.com/live/[a-z0-9-]+/[a-z0-9-]+/[a-z0-9-]+") %>% 
    unlist()
  
  links <- links[!is.na(links)]
  
  stats_link <- c()
  for (link in links){
    new_link <- paste(link, "/stats/", sep = "")
    stats_link <- c(stats_link, new_link)
  }
  return(stats_link)
}


  
