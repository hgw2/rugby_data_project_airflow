get_club_or_international<- function(compitition){
  international <- c("autumn_nations_cup")
  club <- c("premiership")
  if (compitition %in% international){
    return("international")
  } else if (compitition %in% club){
    return("club")
  } else {
    return("unknown")
  }
}

get_club_or_international<- Vectorize(get_club_or_international)