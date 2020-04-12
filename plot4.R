library(dplyr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(grid)

##load data
if(file.exists("household_power_consumption.txt")) {
  data0 <- read.table("household_power_consumption.txt",
                      sep = ";", header = TRUE, stringsAsFactors = FALSE)
} else if(file.exists("exdata-data-household_power_consumption.zip")) {
  data0 <- read.table(unz("exdata-data-household_power_consumption.zip",
                          "household_power_consumption.txt"),
                      sep = ";", header = TRUE, stringsAsFactors = FALSE)
} else {
  temp <- tempfile()
  download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip",temp)
  datax <- read.table(unz(temp, "household_power_consumption.txt"),
                     sep = ";", header = TRUE, stringsAsFactors = FALSE)
  unlink(temp)
}

#extract data from the dates 2007-02-01 and 2007-02-02
data <- datax[(datax$Date=="1/2/2007") | (datax$Date=="2/2/2007"),]
#
data$datetime <- strptime(paste(data$Date, data$Time, sep=" "),"%d/%m/%Y %H:%M:%S")

##plot
dev.copy(png,file="plot4.png",width=480, height=480) 
par(mfrow=c(2,2))

plot(data$datetime, as.numeric(data$Global_active_power), type="l",
     xlab="",
     ylab='Global Active Power')

plot(data$datetime, as.numeric(data$Voltage), type="l",
     xlab="datetime",
     ylab='Voltage')

plot(data$datetime, as.numeric(data$Sub_metering_1), type="l",
     xlab="",
     ylab='Energy sub metering')
lines(data$datetime, as.numeric(data$Sub_metering_2), type="l", col="red")
lines(data$datetime, as.numeric(data$Sub_metering_3), type="l", col="blue")
legend('topright', c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       lty=1, col=c('black','red','blue'), bty='n')

plot(data$datetime, as.numeric(data$Global_reactive_power), type="l",
     xlab="datetime",
     ylab="Global_reactive_power")

dev.off()



