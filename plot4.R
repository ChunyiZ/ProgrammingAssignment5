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

# Finding the Coal-Combustion SCC code

SCC_Coal_Comb <- SCC %>%
  filter(grepl('[Cc]ombustion', SCC.Level.One)) %>%
  filter(grepl("[Cc]oal", SCC.Level.Three)) %>%
  select(SCC, SCC.Level.One, SCC.Level.Three)

# Add the SCC_Coal_Comb to NEI by SCC and create a new one

  NEI_Coal_Comb <- inner_join(NEI, SCC_Coal_Comb, by = "SCC")
  
# Plot the graph
  NEI_Coal_Comb_Plot <- ggplot(NEI_Coal_Comb, aes(factor(year), Emissions)) +
  geom_bar(stat = "identity", fill = "green", width = 0.5) +
  labs(x = "Year", y = "Emissions (Tons)", title = "Total Coal Combustion Related Emissions From 1999 - 2008")+
  theme_dark()
  ggsave("plot4.png")
  print(NEI_Coal_Comb_Plot)
  