#Preparation Work

  library(ggplot2)

#Download the dataset

  filename <- "exdata-data-NEI_data.zip"

#Check if zip existed
  if (!file.exists("exdata-data-NEI_data.zip")){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileURL, filename, method = "curl")
  
}

#Check if rds file existed 

  if(!file.exists("summarySCC_PM25.rds") & !file.exists("Source_Classification_Code.rds"))
    unzip(filename)

#Read table

  NEI<- readRDS("summarySCC_PM25.rds")
  SCC<- readRDS("Source_Classification_Code.rds")

#Subset the Baltimore
  BalPM <- subset(NEI, NEI$fips =="24510")

#Sum Baltimore PM by Year
  BalPMbyYear <- tapply(BalPM$Emissions, BalPM$year, sum)
  
#Export the PNG file
  png(filename = "plot2.png") 
  
#Plot the Result
  
  plot(names(BalPMbyYear), BalPMbyYear, type = "l", ylab = "PM2.5 by tons", xlab = "Year", main = "Baltimore Total PM 2.5 Emissions from 1999 - 2008")
  
#Close the device
  dev.off()    
  