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

## Phase 2: Prepare the data
# Change Date variable from character to Date
targetData$Date <- as.Date(targetData$Date, format = "%d/%m/%Y")

# Add new date/time variable to the data frame
targetData$DateTime <- strptime(paste(targetData$Date, targetData$Time, sep = " "),
                                format="%Y-%m-%d %H:%M:%S", tz = "")

## Phase 3: Duplicate Plot 4 - Multiple Charts
# Open a png file
png(filename = "plot4.png", width = 480, height = 480)


# par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
par(mfcol = c(2, 2), mar = c(4, 4, 1, 1), oma = c(0, 0, 0, 0))

## Chart 1
# Create the line chart
with(targetData, plot(DateTime, Global_active_power,
                      xlab = "",
                      ylab = "Global Active Power",
                      type = "l"))

## Chart 2
# Create the initial line chart
with(targetData, plot(DateTime, Sub_metering_1,
                      xlab = "",
                      ylab = "Energy sub metering",
                      type = "l"))

# Add second line to chart
with(targetData, lines(DateTime, Sub_metering_2, type = "l", col = "red"))

# Add third line to chart
with(targetData, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))

# Add legend to chart
legend("topright", lty = 1, bty = "n",
       col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Chart 3
# Create the line chart
with(targetData, plot(DateTime, Voltage,
                      xlab = "datetime",
                      ylab = "Voltage",
                      type = "l"))

## Chart 4
# Create the line chart
with(targetData, plot(DateTime, Global_reactive_power,
                      xlab = "datetime",
                      type = "l"))

# Close the png file and remove targetData from environment
dev.off()
remove(targetData)
