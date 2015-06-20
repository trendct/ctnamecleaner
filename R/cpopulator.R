#' CT Population Appender
#'  
#' Adds population of CT towns in extra column to dataframe.
#' @name ctpopulator
#' @param name Column with town names
#' @param data Name of dataframe
#' @return Whatever
#' @import dplyr
#' @importFrom stringr str_to_upper
#' @importFrom stringr str_to_lower
#' @importFrom stringr str_to_title
#' @importFrom stringr str_trim
#' @export
#' @examples
#' \dontrun{
#' ctpopulator(name_column, ctdata, filename="analysis")
#' }
NULL 

#' Town populations list
#' @docType data
#' @keywords datasets
#' @format A data frame
#' @name pop
NULL

require(stringr)
require(dplyr)

globalVariables("pop")

ctpopulator <- function(name, data, filename="nope") {
  print("Checking to see if names match...")
  data$name <- as.character(data$name)  
  data$name <- str_to_upper(data$name)
  data$name <- str_trim(data$name)
  
  #pop <- read.csv("data-raw/ctpop.csv", stringsAsFactors=FALSE)
  pop <- pop
  composite <- left_join(data, pop)  
  if (filename != "nope") {
    file <- paste(filename, ".csv", sep="")
    write.csv(composite, file)
    print(paste("Congrats. The new file has been exported and is is called ", file, sep=""))
  } else {
    CTPOPULATED <- composite
    print("Congrats. The new dataframe is called CTPOPULATED.")  
  }
}