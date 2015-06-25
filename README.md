# ctnamecleaner

An R package that finds that takes a list of Connecticut hamlets or neighborhoods and adds a column with the matching official town names. 

- Matches hamlets or neighborhoods to equivalent town names
- Adds additional column with population
-  Optionally exports a new CSV file
-  Lists names that could not be matched to towns
-  Based on an [ever-growing list](https://docs.google.com/spreadsheets/d/1WqZIGk2AkHXKYvd4uXy5a2nwyg529e7mMU5610Ale0g/edit?usp=sharing) of town names that [TrendCT.org](http://www.trendct.org) comes across. 

####What function ctnamecleaner() does
Let's assume you have a dataframe in R called **towncoffeeshops** that looks like

Town | Coffeeshops
--- | ---:
Andover | 2
Centerbrook | 5
Yalesville | 1

*Run this in R*
```ssh
ctnamecleaner(Town, towncoffeeshops, filename="towncoffeecleaned", case="Upper")
```
You'll get a new file called **towncoffeecleaned.csv** that looks like

Town | Coffeeshops | real.town.name
--- | ---: | --- 
Andover | 2 | ANDOVER
Centerbrook | 5 | ESSEX
Yalesville | 1 | WALLINGFORD

####Usage

```ssh
ctnamecleaner(name, data, filename="none", case="Title")
```

####Arguments
- **name** - Column with town names
- **data** - Name of data frame. 
- **filename** Name of CSV to save. If skipped, CSV will not export
- **case** Output of town string. Options are **Upper**, **Lower**, and **Title**


####What function ctpopulator() does
Let's assume you've collapsed duplicate town names column **real.town.name** in the **CTNAMECLEANED** dataframe above and summed up or averaged the figures you were working with. 

*Run this in R*
```ssh
ctpopulator(real.town.name, CTNAMECLEANED, filename="towncoffeepop")
```
You'll get a new file called **towncoffeepop.csv** that looks like the table below. *Note:* if you exclude the CSV **filename** parameter only the dataframe will be exported and can be assigned to a variable. 

Town | Coffeeshops | real.town.name | pop2013
--- | ---: | --- | ---:
Andover | 2 | ANDOVER | 3095
Centerbrook | 5 | ESSEX | 6668
Yalesville | 1 | WALLINGFORD | 45112

####Usage

```ssh
ctnamecleaner(name, data, filename="none")
```

####Arguments
- **name** - Column with town names
- **data** - Name of data frame. 
- **filename** Name of CSV to save. If skipped, CSV will not export.
- **case** Output of town string. Options are **Upper**, **Lower**, and **Title**

####What you'll need to start
  - [R](http://www.r-project.org/)
  - [RStudio](http://www.rstudio.com/) (not really, but sure)

####What to run within R or RStudio
Assuming user is starting from scratch
```ssh
install.packages("devtools")
library(devtools)

install_github("trendct/ctnamecleaner")
library(ctnamecleaner)
```

###What's next
  - Pull list straight from the Google Spreadsheet and not hardcoded data

### Version
0.0.1

MIT