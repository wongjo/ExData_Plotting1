library("stringr")

# a helping function to print to the console
pr <- function(...) {
  cat("[plot1.R]", ..., "\n")
}

dir <- getwd()
pr("Exploratory Data Analysis Course Project 1, part 1 of 4")
pr("Author: Jonah Wong")
pr("---")
pr("Starting up.")

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
# Generate plot 1 of 4, save as PNG format file
pr("  generating plot...")
png(file = "plot1.png", width = 480, height = 480, units = "px", bg = "white")
hist(nexdata$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off() ## Don't forget to close the PNG device!
pr("  saved...")
