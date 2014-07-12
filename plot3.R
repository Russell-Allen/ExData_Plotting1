# Loading and pre-processing of the raw data is in the householdPowerConsumption.R
# file.  All Plots in this assignment use the same data and source this same file.

source('householdPowerConsumption.R');

## For reference, this is a summary of the code (in householdPowerConsumption.R) which loads the data:
#
#    download.file(rawDataSourceUrl, destfile=rawDataLocalFile);
#    #open a file pointer into the zip file (does not fully decompress, allows internal read.)
#    tmp <- unz(rawDataLocalFile, fileNameWithinZip);
#    open(tmp);
#    #read the column names from the first line
#    names <- read.delim(tmp, header=FALSE, colClasses = "character", sep=";", nrows=1);
#    #read the rows of interest (a small fraction of the full data set)
#    data <- read.delim(tmp, header=FALSE, col.names = names, sep=";", na.strings="?", skip=66636, nrows=2880)
#    #delete the names variable, as they were applied to the data
#    rm(names);
#    close(tmp);
#    #clean the data
#    data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S");
#    data$Date <- NULL;
#    data$Time <- NULL;
#    #return as a data.table.
#    data.table(cachedResults);
##

# get the data and store it in the data table called dt
dt <- householdPowerConsumption.get();

# set global plotting settings, namely reduce the text size a bit.
par(cex=.75);

#Plot 3 is a multi-line plot
plot(
    x=dt$DateTime, 
    y=dt$Sub_metering_1, 
    type="l", 
    col="black", 
    xlab="", 
    ylab="Energy sub metering"
);
lines(x=dt$DateTime, y=dt$Sub_metering_2, col="red");
lines(x=dt$DateTime, y=dt$Sub_metering_3, col="blue");

legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c("black","red","blue"));


dev.copy(png, filename="plot3.png", width=480, height=480);
dev.off();