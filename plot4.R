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
    #require(data.table)
    require(dplyr)
    require(ggplot2)
    png('plot4.png', 960, 960, bg="white")
    # Load the NEI & SCC data frames.
    dataset <- readRDS("summarySCC_PM25.rds")
    pollutionSrc <- readRDS("Source_Classification_Code.rds") 

    # Goal: Find all the emissions having SCC code related to Coal Combustion
    # With no domain knowledge, assume that cases-sensitive search for 'coal' 
    # and 'comb' (combustion/combust etc) from EI.Sector is enough
    coalcombustionEI <- unique(grep("comb(.)+coal", pollutionSrc$EI.Sector, perl=T, ignore.case=T, value=T)) 
    SCC_Code <- pollutionSrc[pollutionSrc$EI.Sector %in% coalcombustionEI, ]$SCC
    dataset <- subset(dataset, subset=(dataset$SCC %in% SCC_Code), select=c(Emissions, year))
    dataset <- aggregate(Emissions~year, data=dataset, sum, na.rm=TRUE)


    g <- ggplot(data = dataset, mapping = aes(x=factor(year), y = Emissions)) +
        labs(x="Year",
             y= expression("Total PM"[2.5]*" Emission (Tons)"),
             title=expression("PM"[2.5]*" From US Coal Combustion 1999-2008")) +
        geom_bar(stat='identity', fill='yellow')

    print(g)
    dev.off()
}



# Main
getdata()
plot1()	

rm(list=ls())

