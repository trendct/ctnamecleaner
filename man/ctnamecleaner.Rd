\name{VersionInfo}
\alias{versionInfo}
\title{
CTNameCleaner
}
\description{
Cleans up Connecticut town names and adds population if the user wants and then exports the modified dataframe as a CSV.
}
\Usage{
ctnamecleaner(townnamecolumn, dataframe, filename="combined", case="Title")
}
\Arguments{
filename Whatever you want the CSV file to be called when it's exported. Defaults to combined.
case Upper, Lower, or Title. Defaults to Title.
}
\Examples{
ctnamecleaner(towns, connnecticut)
ctnamecleaner(id, conn, filename="townanalysis", case="Upper")
}
