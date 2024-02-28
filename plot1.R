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

#Total PM Emission by Year
  
  PMbyYear <- tapply(NEI$Emissions, NEI$year, sum)
  
#Export the PNG file
  png(filename = "plot1.png") 

#Plot the Result
  
  plot(names(PMbyYear), PMbyYear, type = "l", ylab = "PM2.5 by tons", xlab = "Year", main = "Total PM 2.5 Emissions from 1999 - 2008")

#Close the device
  dev.off()  
  