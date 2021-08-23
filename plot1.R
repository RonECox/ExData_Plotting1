## Phase 1: Acquire the data
# Create a temporary file to store the downloaded zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(fileUrl, temp)

# Get a list of the files in the zip file
zipFiles <- unzip(zipfile = temp, list = TRUE)

# Read in 'household_power_consumption.txt' from the zip file using its index in zipFiles
allData <- read.csv(unz(temp, zipFiles$Name[1]), header = TRUE, sep = ";", na.strings = "?",
                    colClasses = c("character", "character", "numeric",
                                   "numeric", "numeric", "numeric", "numeric",
                                   "numeric", "numeric"))

# Subset the data set by filtering on the target date range 1-2 Feb 2007
targetData <- subset(allData, Date %in% c('1/2/2007', '2/2/2007'))

# Close the connection to the temporary file and remove unnecessary objects
unlink(temp)
remove(allData, zipFiles, fileUrl, temp)

## Phase 2: Duplicate Plot 1 - Histogram
# Open a png file
png(filename = "plot1.png", width = 480, height = 480)
hist(targetData$Global_active_power,
     main = "Global Active Power", col = "red",
     xlab = "Global Active Power (kilowatts)")
# Close the png file and remove targetData from environment
dev.off()
remove(targetData)
