
library(tidyverse)
  library(sjmisc)
  library(stringdist)
  library(plyr)
  library(dplyr)
  library(openxlsx)
  library(readxl)
  library(data.table)
  library(readr)
  library(stringr)
#function- ## here you dont need to change anything##
ClonesAnalysis<- function(shared_seq_with_mut,WorkingDirectory){
  
  #set working directory
  setwd(WorkingDirectory)
  #variable
  my_variable<-shared_seq_with_mut
  ###load empty df
  clones_output <- as.data.frame(read_excel("Z:/Ligal/Ligal  - MyDocs/data for R practice/clones output.xlsx"))
  #######################################Nucleutide###############################
  #calculate no. of uniqe clones
  clones_df<-ddply(my_variable,.(CDR3,`V hit`,`J hit`),nrow) #clustring
  
  #clustring by CDR3+V+J
  for (i in 1:nrow(clones_df)){
    subset_df <- my_variable %>% filter(CDR3 == clones_df[i,1], `V hit` == clones_df[i,2],`J hit` == clones_df[i,3])
    no_transcripts<-sum(my_variable$No_transcripts) #transcripts are all seq with the same CDR3, V,J 
    no_members_df<- ddply(subset_df,.(seq),nrow) #members are only the uniqe seq with the same CDR3, V,J   
    clones_output[i,1]<-clones_df[i,1]
    clones_output[i,2]<-clones_df[i,2]
    clones_output[i,3]<-clones_df[i,3]
    clones_output[i,4]<-nrow(subset_df)
    clones_output[i,5]<- nrow(no_members_df) 
    clones_output[i,6]<- mean(subset_df$count)
  } 
  #filter-out empty CDR3 seq
  clones_output<-clones_output %>% filter_all(all_vars(!is.na(clones_output$CDR3)))
  #calculate freq 
  clones_output$frequency	<-prop.table(clones_output$`no of trancripts`)
  #sort from large to small
  setorder(clones_output,-frequency)
  #add CDR3 Length
  clones_output$`CDR3 length`<- nchar(clones_output$CDR3)
  #add acumulative percent
  clones_output$cumulative<- cumsum(clones_output$frequency)
  #p^2 for hill number
  clones_output$`p^2`<-(clones_output$frequency)^2
  #hill number calculation for q=2
  clones_output$HillNumber<- (sum(clones_output$`p^2`))^(1/1-2)
  #add index
  clones_output$id<- 1:nrow(clones_output)
  list_output<- list(clones_output)
  return(list_output)
}
#use function- here you need to insert shared seq with mutation count file and working directory
list1<- ClonesAnalysis(shared_seq_with_mut,"~/My Desktop/Hammpers project")
#unlist
clones_output<-list1[[1]]
#remove NA CDR3
clones_output<-subset(clones_output, clones_output$CDR3!="NA")
#export data to excel#
write.xlsx(clones_output, "clones analysis.xlsx")
  
