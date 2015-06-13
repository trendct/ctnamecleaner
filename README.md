# ctnamecleaner

An R package that finds that takes a list of Connecticut hamlets or neighborhoods and adds a column with the matching official town names. 

- Matches hamlets or neighborhoods to equivalent town names
-  Also asks if you would like an additional column with town population numbers
-  Exports a new CSV file automatically
-  Lists names that could not be matched to towns
-  Based on an [ever-growing list](https://docs.google.com/spreadsheets/d/1WqZIGk2AkHXKYvd4uXy5a2nwyg529e7mMU5610Ale0g/edit?usp=sharing) of town names that [TrendCT.org](http://www.trendct.org) comes across. 


#####What it does
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
*This response will appear*
```ssh
Would you also like to add a column for town population?
(y/n)
```
If you press **y** and enter, you'll get a new file called **towncoffeecleaned.csv** that looks like

Town | Coffeeshops | real.town.name | pop2013
--- | ---: | --- | ---:
Andover | 2 | ANDOVER | 3095
Centerbrook | 5 | ESSEX | 6668
Yalesville | 1 | WALLINGFORD | 45112

#####Usage

```ssh
ctnamecleaner(name, data, filename="combined", case="Title")
```

#####Arguments
- **name** - Column with town names
- **data** - Name of data frame
- **filename** Name of CSV to save
- **case** Output of town string. Options are **Upper**, **Lower**, and **Title**


#####What you'll need to start
  - [R](http://www.r-project.org/)
  - [RStudio](http://www.rstudio.com/) (not really, but sure)

#####What to run within R or RStudio
Assuming user is starting from scratch
```ssh
install.packages("devtools")
library(devtools)

install_github("trendct/ctnamecleaner")
library(ctnamecleaner)
```
### Version
0.0.0.9

MIT