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

ctnamecleaner <- function(name, data, filename="nope", case="Title") {
  data$name <- as.character(data$name)  
  data$name <- str_to_upper(data$name)
  data$name <- str_trim(data$name)
  the_list <- the_list
  #the_list <- read.csv("data-raw/townlist.csv", stringsAsFactors=FALSE)
  the_list$name <- str_trim(the_list$name)
  composite <- left_join(data, the_list)

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
  
  if (sum(is.na(composite$real.town.name)) > 0 ) {
    bad_names <- subset(composite, is.na(composite$real.town.name))
    cat("Your file with fixed town names has been exported. \nUnfortunately, no matches were found for: ", bad_names$name, " ")
  } else {
    print("...All names matched. That's a good thing.")
  }
  
  if (filename != "nope") {
  file <- paste(filename, ".csv", sep="")
  write.csv(composite, file)
  print(paste("Congrats. The new file has been exported and is is called ", file, sep=""))
  } else {
    CTNAMECLEANED <- composite
    print("Congrats. The new dataframe is called CTNAMECLEANED. \nDon't forget to collapse the duplicate rows and sum/average the numeric columns.")  
  }
}
