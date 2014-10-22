rm(list=ls())

getdata <- function() {
    # Download and prep data file is absent
    targetfile<-'exdata_data_NEI_data.zip'
    if(!(file.exists(targetfile) | file.exists("Source_Classification_Code.rds"))) {
        url<-'https://d396qusza40orc.cloudfront.net/exdata/data/NEI_data.zip'
        download.file(url=url, destfile=targetfile, method='wget')
        unzip(zipfile=targetfile, overwrite=TRUE)
        file.remove(targetfile)
        
    }
    rm(targetfile)
    TRUE
}

plot1<-function(){
    require(plyr)
    png('plot1.png', 480, 480, units="px",bg="white")
    # Load the NEI & SCC data frames.
    NEI <- readRDS("summarySCC_PM25.rds")
    # Sum Emissions by year, tur to Million Tons
    dataset <- aggregate(Emissions~year, data=NEI, sum)
    dataset$Emissions <- dataset$Emissions/10e6
    plot(x=dataset$year, y=dataset$Emissions, type='b', xlab = 'Year', ylab='Emissions Total (Million Tons)', main=bquote(PM[25] ~ 'total Emissions per Year'))
    dev.off()
}



# Main
getdata()
plot1()	

rm(list=ls())

