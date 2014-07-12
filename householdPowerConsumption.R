# This function requires the data.table library to be installed.
library(data.table);

# householdPowerConsumption provides two methods:
#   get     return a data.table of the householdPowerConsumption data for 2007/2/1 and 2007/2/2
#   rest    clears the internally cached data
#
# Thid function provides the raw data for a set of plots for the associated assignment.  They all
# work off the same data, and there is no reason to redownload a 20 MB file, and extract a nearly
# 120 MB delimited file.  Instead, this function performs the download once (into working dir)
# and will reuse the file if it exists there.  DO NOT EDIT THE FILE, OR YOU INVALIDATE THE DATA.
householdPowerConsumption <- function() {
    
    ## Settings ##
    # Remote location of origial data
    rawDataSourceUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
    # local (in working directory) version of original data
    rawDataLocalFile <- "exdata-data-household_power_consumption.zip";
    # The file name within the zip file.  This should not change.
    fileNameWithinZip <- "household_power_consumption.txt";
    
    ## private data ##
    # Keep a cached reference to the data table so that we don't repull and parse it.
    cachedResults <- NULL;
    
    ## "Result" is a list of functions ""
    list(
        get = function() {
            if (is.null(cachedResults)) {
                #Do we need to download the file?
                if (! file.exists(rawDataLocalFile) ) {
                    download.file(rawDataSourceUrl, destfile=rawDataLocalFile);
                }
                #open a file pointer into the zip file (does not fully decompress, allows internal read.)
                tmp <- unz(rawDataLocalFile, fileNameWithinZip);
                open(tmp);
                #read the column names from the first line
                names <- read.delim(tmp, header=FALSE, colClasses = "character", sep=";", nrows=1);
                #read the rows of interest (a small fraction of the full data set)
                data <- read.delim(tmp, header=FALSE, col.names = names, sep=";", na.strings="?", skip=66636, nrows=2880)
                #delete the names variable, as they were applied to the data
                rm(names);
                close(tmp);
                #clean the data
                data$DateTime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S");
                data$Date <- NULL;
                data$Time <- NULL;
                #cache the result
                cachedResults <<- data;
            }
            #return as a data.table.  Note, don't cache the data.table as edits on it will change the internal cached version.
            data.table(cachedResults);
        },
        reset = function() {
            cachedResults <<- NULL;
        }
    )
}

# There's probably a better way to do this, but the following creates the closure 
# and then removes any reference to householdPowerConsumption as a function.  In
# its place it leaves the get and reset functions.  This is great encapsulation,
# but like I said... there's probably a much better way to go about this.

householdPowerConsumption <- householdPowerConsumption()
householdPowerConsumption.get <- householdPowerConsumption$get
householdPowerConsumption.reset <- householdPowerConsumption$reset
rm(householdPowerConsumption)
