library("stringr")

# a helping function to print to the console
pr <- function(...) {
  cat("[plot4.R]", ..., "\n")
}

dir <- getwd()
pr("Exploratory Data Analysis Course Project 1, part 4 of 4")
pr("Author: Jonah Wong")
pr("---")
pr("Starting up.")

# This section checks to see if nexdata from plot1.R was generated, and if not, then generates the data frame
if(!exists("nexdata"))
{
  fileName  <- "household_power_consumption.txt"

  # This section checks if the target data file is in the the current working directory.
  # If not, the program downloads the original zipped data file and unzips file to the current working directory
  if(!(file.exists(fileName))) 
    {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    zipfileName <- "exdata-data-household_power_consumption.zip"
    pr("Downloading zipped dataset from internet to: ", paste(dir,zipfileName))
    download.file(fileUrl, destfile = zipfileName, method = "curl")
    pr("  unzipping data file...")
    unzip(zipfileName)
    }

  # Read the text data file
  pr("  reading data file...")
  varclasses <- c(rep("character", 2), rep("numeric", 7))
  exdata <- read.table(fileName, na.strings = "?", header = TRUE, sep = ";", colClasses = varclasses)
  # combine Date and Time text fields and convert to POSIXlt format
  nexdata <- data.frame(DateTime=paste(exdata$Date, exdata$Time), exdata[3:9], stringsAsFactors = FALSE)
  nexdata$DateTime <- strptime(nexdata$DateTime, format = "%d/%m/%Y %H:%M:%S")
  # select the February 1st to 2nd readings in 2007
  pr("  selecting data...")
  nexdata <- subset(nexdata,(nexdata$DateTime >= "2007-02-01 00:00:00" & nexdata$DateTime <= "2007-02-02 23:59:59"))
}
# Generate plot 4 of 4, save as PNG format file
pr("  generating plot...")
png(file = "plot4.png", width = 480, height = 480, units = "px", bg = "white")
par(mfrow=c(2,2))
with(nexdata, plot(DateTime, Global_active_power, col="black", type ="l", xlab="", ylab = "Global Active Power (kilowatts)"))
with(nexdata, plot(DateTime, Voltage, col="black", type ="l", xlab="datetime", ylab = "Voltage"))
with(nexdata, plot(DateTime, Sub_metering_1, col="black", type ="l", xlab="", ylab = "Energy Sub metering"))
lines(nexdata$DateTime, nexdata$Sub_metering_2, col="red", type ="l")
lines(nexdata$DateTime, nexdata$Sub_metering_3, col="blue", type ="l")
legend("topright", names(nexdata[6:8]), cex=0.8, col=c("black", "red", "blue"), lty = 1, bty="n")
with(nexdata, plot(DateTime, Global_reactive_power, col="black", type ="l", xlab="datetime"))
dev.off() ## Don't forget to close the PNG device!
pr("  saved...")
