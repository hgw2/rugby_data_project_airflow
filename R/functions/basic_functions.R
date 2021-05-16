get_club_or_international<- function(compitition){
  international <- c("autumn_nations_cup","six_nations", "the_rugby_championship", "internationals", "rugby_world_cup")
  club <- c("premiership", "premiership_cup", "pro_14","top_14", "european-champions-cup", "challenge_cup", "mitre_10_cup",
            "currie_cup")
  if (compitition %in% international){
    return("international")
  } else if (compitition %in% club){
    return("club")
  } else if (str_detect(compitition, "super_rugby") |str_detect(compitition, "rainbow_cup") ){
    return("club")
  
    }else {
    return("unknown")
  }
}

get_club_or_international<- Vectorize(get_club_or_international)