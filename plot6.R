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
BalLosPM <- subset(NEI, NEI$fips =="24510" | NEI$fips =="06037")
BalLosVehiclePM <- BalLosPM %>% 
  select(fips, SCC, year, Emissions) %>%
  inner_join(SCC_Motor, by = "SCC") %>%
  group_by(fips, year) %>%
  summarise (Emissions = sum(Emissions, na.rm = TRUE))

# Replace the fips code to realname

  BalLosVehiclePM$fips <- gsub("24510", "Baltimore",BalLosVehiclePM$fips)
  BalLosVehiclePM$fips <- gsub("06037", "Los Angels", BalLosVehiclePM$fips)

# Seperate two the BalLosVehiclePM into two parts for graphing
  
  BalPMGraph <- subset(BalLosVehiclePM, fips == "Baltimore")
  LosPMGraph <- subset(BalLosVehiclePM, fips == "Los Angels")

  
# Plot the graph
BalLosVehiclePMPlot <- ggplot(BalPMGraph, aes(x = year, y = Emissions)) +
  geom_line (color = "red") +
  ggplot(LosPMGraph, aes(x = year, y = Emissions)) +
  geom_line (color = "green")
 ggsave("plot6.png")
print(BalLosVehiclePMPlot)


