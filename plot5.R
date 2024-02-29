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

# Finding the Finding the Motor Vehicle SCC code

SCC_Motor <- SCC %>%
  filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
  select(SCC, SCC.Level.Two)

# Filter Out Baltimore from NEI
  BalPM <- subset(NEI, NEI$fips =="24510")
  BalVehiclePM <- BalPM %>% 
    select(SCC, year, Emissions) %>%
    inner_join(SCC_Motor, by = "SCC") %>%
    group_by(year)

# Plot the graph
  BalVehiclePMPlot <- ggplot(BalVehiclePM, aes(factor(year), Emissions)) +
    geom_bar(stat = "identity", fill = "green", width = 0.5) +
    labs(x = "Year", y = "Emissions (Tons)", title = "Baltimore Vehicle Emissions From 1999 - 2008")+
    theme_dark()
  ggsave("plot5.png")
  print(BalVehiclePMPlot)
  