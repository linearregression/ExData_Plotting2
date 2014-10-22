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
    require(data.table)
    png('plot2.png', 480, 480, units="px",bg="white")
    # Load the NEI & SCC data frames.
    NEI <- as.data.table(readRDS("summarySCC_PM25.rds"), keep.rownames=F)
    SCC <- as.data.table(readRDS("Source_Classification_Code.rds"), keep.rownames=F)
    # Sum of Emissions in Baltimore, Maryland(fips==24510) 
    # by year to Million Tons
    dataset <- NEI[, .SD[, fips==24510, Emissions], by=year]
    
    plot(x=dataset$year, y=dataset$Emissions, type='b', xlab = 'Year', ylab='Emissions Total (Million Tons)', main='Baltimore: Total PM25 Emissions vs Year ')   
    dev.off()
}



# Main
getdata()
plot1()	

rm(list=ls())

