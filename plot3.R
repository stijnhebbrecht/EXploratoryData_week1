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
  data <- read.table(unz(temp, "household_power_consumption.txt"),
                     sep = ";", header = TRUE, stringsAsFactors = FALSE)
  unlink(temp)
}

##convert file
data0 <- tbl_df(data0)
dataFil <- filter(data, Date == "2/2/2007" | Date == "1/2/2007")
dataFil <- mutate(dataFil, Date_Time = paste(Date, Time, sep = " "))
dataFil$Date_Time <- strptime(dataFil$Date_Time, "%d/%m/%Y %H:%M:%S")
dataFil[, 3:9] <- lapply(dataFil[, 3:9], as.numeric)
dataFil <- dataFil[, c(10, 3:9)]

##plot

plot(dataFil$Date_Time, dataFil$Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
lines(dataFil$Date_Time, dataFil$Sub_metering_2, type="l", col="red")
lines(dataFil$Date_Time, dataFil$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2.5, col=c("black", "red", "blue"))
dev.copy(png,file="plot3.png",width=480, height=480) 
dev.off()

