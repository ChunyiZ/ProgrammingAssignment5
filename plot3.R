#Preparation Work

library(ggplot2)
library(dplyr)

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

#Group the data by year and by type

BalPMbyYearbyType <- BalPM %>% 
          select(year, type, Emissions) %>%
          group_by(year, type) %>%
          summarise(Total_Emissions = sum(Emissions,na.rm = TRUE))

#Plot

BaltimorebyYearbyTypePlot <- ggplot(BalPMbyYearbyType, aes(x = factor(year), y = Total_Emissions, fill = type)) +
    geom_bar(stat = "identity") +
    facet_grid(.~type)+
    labs(x = "Year", y = "Emissions in Tons", title = "Total Baltimore PM 2.5 by Type from 1999 - 2008")+
    ggsave("plot3.png")

print(BaltimorebyYearbyTypePlot)  
