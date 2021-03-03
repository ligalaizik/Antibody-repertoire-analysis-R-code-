
library(readxl)
library(openxlsx)
#set working directory
setwd("")

#import datasets (clones analysis)
#timepoint 1
my_data1 <- read_excel("clones analysis.xlsx")
#time point 2
my_data2 <- read_excel("clones analysis.xlsx")

#find shared clones   
shared_clones_12<- merge.data.frame(my_data1, my_data2, by= c("CDR3","V","J"))

##export df
write.xlsx(shared_clones_12 ,"shared clones.xlsx")










