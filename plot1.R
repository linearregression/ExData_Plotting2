rm(list=ls())
require(sqldf)
tmpdbname <- NULL

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
    png('plot1.png', 480, 480, bg = "white")
    library(sqldf)
    
    dev.off()
}



# Main
getdata()
plot1()	

rm(list=ls())
