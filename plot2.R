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
    
    # Sum of Emissions in Baltimore, Maryland(fips==24510) 
    # by year to Million Tons
    dataset <- subset(NEI, subset=(fips=='24510'), select=c(Emissions, year))

    dataset <- aggregate(Emissions~year, data=dataset, sum) 
    plot(x=dataset$year, y=dataset$Emissions/10e6, type='b', xlab = 'Year', ylab='Emissions Total (Million Tons)', main=bquote(PM[25] ~ 'total Emissions in Baltimore per Year'))   
    dev.off()
}



# Main
getdata()
plot1()	

rm(list=ls())

