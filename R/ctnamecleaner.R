#' CT Town name cleaner
#'  
#' Cleans up Connecticut town names.
#' @name ctnamecleaner
#' @param name Column with town names
#' @param data Name of dataframe
#' @param filename Name of CSV to save
#' @param case Output of town string. Options are \code{Upper}, \code{Lower}, and \code{Title}
#' @return Whatever
#' @import dplyr
#' @importFrom stringr str_to_upper
#' @importFrom stringr str_to_lower
#' @importFrom stringr str_to_title
#' @importFrom stringr str_trim
#' @export 
#' @examples
#' \dontrun{
#' ctnamecleaner(name_column, ctdata, filename="analysis", case="Upper")
#' }
NULL 

#' Assorted town names list
#' @docType data
#' @keywords datasets
#' @format A data frame
#' @name the_list
NULL

require(stringr)

require(dplyr)
globalVariables("the_list")


#library(plyr) 
#df <- data.frame(foo=rnorm(1000)) 
#df <- rename(df,c('foo'='samples'))

ctnamecleaner <- function(name, data, filename="nope", case="Title") {
  CTDATA <- data
  newdata <- as.list(match.call())
  thename <- as.character(newdata$name)
  names(data)[names(data)==thename] <- "name2"
    
  data$name2 <- as.character(data$name2)  
  data$name2 <- str_to_upper(data$name2)
  data$name2 <- str_trim(data$name2)
  #updating the_list
  #the_list <- read.csv("data-raw/townlist.csv", stringsAsFactors=FALSE)
  #save(the_list, file="data/the_list.rda")
  colnames(the_list) <- c("name2", "real.town.name")
  the_list$name2 <- str_trim(the_list$name2)
  composite <- left_join(data, the_list)

  if (case=="Upper") {
    composite$name2 <- str_to_upper(composite$name2)
    composite$real.town.name2 <- str_to_upper(composite$real.town.name2)
  } else if (case=="Lower") {
    composite$name2 <- str_to_lower(composite$name2)
    composite$real.town.name2 <- str_to_lower(composite$real.town.name2)
  } else {
    composite$name2 <- str_to_title(composite$name2)
    composite$real.town.name <- str_to_title(composite$real.town.name)
  }
  
  if (sum(is.na(composite$real.town.name)) > 0 ) {
    bad_names <- subset(composite, is.na(composite$real.town.name))
    cat("Your file with fixed town names has been exported. \nUnfortunately, no matches were found for ", nrow(bad_names), " ")
    cat("They can be found in your folder. The file is called no_matches.csv")
    write.csv(bad_names$name2, "no_matches.csv")
  } else {
    print("...All names matched. That's a rare thing.")
  }
  
  names(composite)[names(composite)=="name2"] <- thename
  
  if (filename != "nope") {
  file <- paste(filename, ".csv", sep="")
  write.csv(composite, file)
  cat(paste("\nCongrats. The new file has been exported and is is called ", file, sep=""))
  } else {
    CTDATA <<- composite
    cat("Congrats. The new dataframe is called CTDATA. \nDon't forget to collapse the duplicate rows and sum/average the numeric columns.")  
  }
}
