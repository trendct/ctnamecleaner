#' CT Correlation Finder
#'  
#' Compares an array town data to ~500 variables to check if there are any strong correlations. Exports two CSV files and one chart.
#' @name ctcorrelator
#' @param dat_data Dataframe to compare. Columns must be labeled "town" and "variable". Highly recommend running ctnamecleaner() on it to make sure town names match.
#' @param p Sets Pearson product-moment correlation coefficient. Default is .9.
#' @return Whatever
#' @import dplyr
#' @import RCurl
#' @import reshape
#' @import ggplot2
#' @importFrom stringr str_to_upper
#' @importFrom stringr str_to_lower
#' @importFrom stringr str_to_title
#' @importFrom stringr str_trim
#' @export
#' @examples
#' \dontrun{
#' ctcorrelator <- function(dat_data, p=.9) 
#' }
NULL 

require(stringr)
require(dplyr)
require(RCurl)
require(reshape)
require(ggplot2)

# pull main spreadsheet that has all links and spreadsheet details

ctcorrelator <- function(dat_data, p=.9) {

url <- "https://docs.google.com/spreadsheets/d/1TMN4Di8O7ROUDgylb7IvtnfNtblbwoHy-dpgId6FT3E/pub?output=csv&id=1TMN4Di8O7ROUDgylb7IvtnfNtblbwoHy-dpgId6FT3E"
the_csv <- getURL(url,.opts=list(ssl.verifypeer=FALSE))
master_dataframe <- read.csv(textConnection(the_csv))
master_dataframe <- master_dataframe %>%
  filter(!grepl(".error",column.abbrev))

# create dataframe of just the links to download
mdf_links <- master_dataframe %>%
  group_by(spreadsheet) %>%
  filter(row_number()==1) %>%
  select(spreadsheet, link)

# loop to download each spreadsheet and create one huge mega dataframe
# (I'll go back and replace this with an apply function eventually)

mdf_links_list <- 1:nrow(mdf_links)

for (i in mdf_links_list) {
  url <- mdf_links$link[i]
  the_csv <- getURL(url,.opts=list(ssl.verifypeer=FALSE))
  mdf_sheet <- read.csv(textConnection(the_csv))
  if (i != 1) {
    mdf_master <- left_join(mdf_master, mdf_sheet)
  } else {
   mdf_master <- mdf_sheet
  }
}

# Compare target dataframe with the huge mega dataframe to find correlations

target <- dat_data

target_col_names <- colnames(target)
target_col_names <- str_to_title(target_col_names) 

colnames(target) <- str_to_lower(colnames(target)) 

colnames(target) <- c("town", "overdoses")
  
original_array <- target
corr_list <- 2:ncol(mdf_master)

for (i in corr_list) {
  isolated <- mdf_master[c(1,i)]
  to_correlate <- target
  join_for_correlation <- left_join(to_correlate, isolated)
  column.abbrev <- colnames(mdf_master[i])
  corre <- cor(join_for_correlation[,2], join_for_correlation[,3], use="pairwise.complete.obs")
  loop_array <- data.frame(column.abbrev, corre)
  if (i == 2) {
    array <- loop_array } else 
    { array <- rbind(array, loop_array) }
}

# Adding labels to original correlation array

array <- array[complete.cases(array),]

array <- array %>%
  filter(!grepl(".error",column.abbrev))

array$correlation <- "temp"
for (i in 1:nrow(array)) {
    if (array$corre[i] < -.9) {
      array$correlation[i] <- "very.strong.negative.correlation"
    } else if ((array$corre[i] >= -.9) & (array$corre[i] < -.5)) {
      array$correlation[i] <- "strong.negative.correlation"
    } else if ((array$corre[i] >= -.5) & (array$corre[i] < -.3)) {
      array$correlation[i] <- "moderate.negative.correlation"
    } else if ((array$corre[i] >= -.3) & (array$corre[i] < -.1)) {
      array$correlation[i] <- "weak.negative.correlation"
    } else if ((array$corre[i] >= -.1) & (array$corre[i] < .1)) {
      array$correlation[i] <- "no.correlation"
    } else if ((array$corre[i] >= .1 & array$corre[i] < .3)) {
      array$correlation[i] <- "weak.positive.correlation"
    } else if ((array$corre[i] >= .3) & (array$corre[i] < .5)) {
      array$correlation[i] <- "moderate.positive.correlation"
    } else if ((array$corre[i] >= .5) & (array$corre[i] < .9)) {
      array$correlation[i] <- "strong.positive.correlation"
    } else if (array$corre[i] >= .9) {
      array$correlation[i] <- "very.strong.positive.correlation"
    } else {
      array$correlation[i] <- "NA"
    } 
}

# sort correlations, spit out the summary

array_summary <- array %>%
  group_by(correlation) %>%
  summarise(n())

print(array_summary)
print("summary exported to array_summary.csv")

write.csv(array_summary, "array_summary.csv")

# Filter just the strong and very strong correlations

strong.very.strong <- array %>%
  filter(correlation=="very.strong.negative.correlation" | 
         correlation=="strong.negative.correlation" |  
         correlation=="strong.positive.correlation" |
         correlation=="very.strong.positive.correlation") %>%
  mutate(raw=abs(corre)) %>%
  arrange(-raw)

# selecting just the 
m_df_names <- master_dataframe %>%
  select(column.name, column.abbrev)

strong.very.strong <- left_join(strong.very.strong, m_df_names)  

write.csv(strong.very.strong, "strong.very.strong.csv")
print("variables with strong/very strong correlations has been exported as strong.very.strong.csv")
very.correlated <- strong.very.strong %>%
  filter(raw >= p)

very.strong.list <- very.correlated[c("column.abbrev")]

mdf_copy <- mdf_master
saved_column_names <- colnames(mdf_copy)
saved_column_names <- saved_column_names[-1]
saved_row_names <- mdf_copy[,1]
mdf_copy <- mdf_copy[,-1]

transposed_master <- data.frame(t(mdf_copy))
colnames(transposed_master) <- saved_row_names
transposed_master$column.abbrev <- rownames(transposed_master)
rownames(transposed_master) <-NULL

# joining to very strong

very.strong.data.frame <- left_join(very.strong.list, transposed_master)

saved_column_names2 <- colnames(very.strong.data.frame)
saved_row_names2 <- very.strong.data.frame[,1]
very.strong.data.frame <- very.strong.data.frame[,-1]

very.strong.data.frame <-data.frame(t(very.strong.data.frame))
colnames(very.strong.data.frame) <- saved_row_names2
very.strong.data.frame$town <- rownames(very.strong.data.frame)
rownames(very.strong.data.frame) <- NULL

very.strong.data.frame <- left_join(target, very.strong.data.frame)

mdata <- melt(very.strong.data.frame, id=c("town","overdoses"))

sp <- ggplot(mdata, aes(x=value, y=overdoses)) + geom_point(shape=1)
sp + facet_wrap(~ variable, ncol=3, scales="free_x")

ggsave("plot.png",scale=2)
exit_line <- paste("Charts of all correlations higher than", p, "have been exported as plot.png")
print(exit_line)

}