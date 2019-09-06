# Libraries used 
library(data.table)


#################################################################################
# This code below cleans the Paper table. 
#################################################################################

# Read in the CSV 
paperfull <- read.csv(file="paper.csv", header=TRUE, sep=",")

# Remove columns 
# https://stackoverflow.com/questions/4605206/drop-data-frame-columns-by-name 
paperfull <- subset(paperfull, select = -c(summary))
paperfull <- subset(paperfull, select = -c(arnet_id))
paperfull <- subset(paperfull, select = -c(venue))
paperfull <- subset(paperfull, select = -c(csx_id))

# Remove Special Characters 
# https://stackoverflow.com/questions/21641522/how-to-remove-specific-special-characters-in-r
paperfull$title <- sub("'", "", paperfull$title)
paperfull$title <- sub("\"", "", paperfull$title)

# Write to CSV file 
write.csv(paperfull, 'papercleaned.csv', row.names=FALSE)




#################################################################################
# This code below calculates out the number of times a paper has been cited
# and the number of times a paper cites another paper in this dataset
#################################################################################


# Read in the CSV files 
citing <- read.csv(file="citation.csv", header=TRUE, sep=",")
paper <- read.csv(file="papercleaned.csv", header=TRUE, sep=",")


# Number of times this particular papers is cited
# https://stackoverflow.com/questions/1923273/counting-the-number-of-elements-with-the-values-of-x-in-a-vector
citingfreq <- as.data.frame(table(citing$cited))

# Number of times paper cites other papers. Eg references another paper.....
citedfreq <- as.data.frame(table(citing$citing))


# Write to CSV file
write.csv(paperfull, 'citingfreq.csv', row.names=FALSE)


# Convert to Numeric 
# https://stackoverflow.com/questions/2288485/how-to-convert-a-data-frame-column-to-numeric-type
citingfreq$Var1 <- as.numeric(as.character(citingfreq$Var1))
citedfreq$Var1 <- as.numeric(as.character(citedfreq$Var1))

# Join the tables 
# https://stackoverflow.com/questions/1299871/how-to-join-merge-data-frames-inner-outer-left-right
dt3 <- data.table(citingfreq, key = "Var1")
dt4 <- data.table(paper, key = "id")

joined.dt3.dt.4 <- dt3[dt4]


# Join the tables 
dt4 <- data.table(citedfreq, key = "Var1")
dt5 <- data.table(joined.dt3.dt.4, key = "Var1")

joined.dt4.dt.5 <- dt4[dt5]


# Rename the columns 
names(joined.dt4.dt.5)[names(joined.dt4.dt.5) == 'Var1'] <- 'id'
names(joined.dt4.dt.5)[names(joined.dt4.dt.5) == 'Freq'] <- 'num_papers_cited'
names(joined.dt4.dt.5)[names(joined.dt4.dt.5) == 'i.Freq'] <- 'num_citations'



# Write to CSV files and assign any NA values to 0. 
write.csv(joined.dt4.dt.5, 'test.csv', row.names=FALSE, na = "0")


