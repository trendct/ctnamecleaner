
# ctnamecleaner(name, data, filename="combined", case="Title")
library(dplyr)
library(stringr)

ctnamecleaner <- function(name, data, filename="combined", case="Title") {
  data$name <- as.character(data$name)  
  data$name <- str_to_upper(data$name)
  the_list <- read.csv("townlist.csv", stringsAsFactors=FALSE)

  composite <- left_join(data, the_list)

  file <- paste(filename, ".csv", sep="")

cat("\nWould you also like to add a column for town population?")
step <- readline("(y/n)  ")

if (step=="y" | step=="Y" | step=="Yes" | step=="yes") {
  pop <- read.csv("ctpop.csv", stringsAsFactors=FALSE)
  composite <- left_join(composite, pop)  
  if (case=="Upper") {
    composite$name <- str_to_upper(composite$name)
    composite$real.town.name <- str_to_upper(composite$real.town.name)
  } else if (case=="Lower") {
    composite$name <- str_to_lower(composite$name)
    composite$real.town.name <- str_to_lower(composite$real.town.name)
  } else {
    composite$name <- str_to_title(composite$name)
    composite$real.town.name <- str_to_title(composite$real.town.name)
  }
  write.csv(composite, file)
  if (sum(is.na(composite$real.town.name)) > 0 ) {
    bad_names <- subset(composite, is.na(composite$real.town.name))
    cat("Your file with fixed town names has been exported. \nUnfortunately, no matches were found for: ", bad_names$name, " ")
  } else {
    print("Congrats. Town names scanned, population. New has been file exported.")
  }  
} else if (step=="n" | step=="N" | step=="No" | step=="no") {
  if (case=="Upper") {
    composite$name <- str_to_upper(composite$name)
    composite$real.town.name <- str_to_upper(composite$real.town.name)
  } else if (case=="Lower") {
    composite$name <- str_to_lower(composite$name)
    composite$real.town.name <- str_to_lower(composite$real.town.name)
  } else {
    composite$name <- str_to_title(composite$name)
    composite$real.town.name <- str_to_title(composite$real.town.name)
  }
  
  write.csv(composite, file)
    if (sum(is.na(composite$real.town.name)) > 0 ) {
      bad_names <- subset(composite, is.na(composite$real.town.name))
      cat("Your file with fixed town names has been exported. \nUnfortunately, no matches were found for: ", bad_names$name, " ")
    } else {
      print("Congrats. Town names scanned. New has been file exported.")
    }
} else print("Sorry, your choice is not recognized")

}