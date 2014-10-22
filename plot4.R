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
    # Sum of Emissions in Baltimore, Maryland(fips==24510) 
    # by year to Million Tons
    dataset <- subset(dataset, subset=(fips=='24510'), select=c(Emissions, type, year))
    dataset <- aggregate(Emissions ~type + year, data=dataset, sum, na.rm=TRUE)
    g <- ggplot(data = dataset, mapping = aes(x=factor(year), y = Emissions, fill=type)) +
        layer(geom = 'histogram', geom_params = list(color = 'steelblue'), stat = 'identity') +
        facet_grid(. ~type, scales = "free", space="free") + 
        labs(x="Year",
             y= expression("Total PM"[2.5]*" Emission (Tons)"),
             title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type")) 

    print(g)
    dev.off()
}



# Main
getdata()
plot1()	

rm(list=ls())

