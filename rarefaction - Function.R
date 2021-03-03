library(readxl)
library(ggthemes)
library(dplyr)

#FUNCTION- ## here you dont need to change anything##
RareFaction<- function(shared_seq,WorkingDirectory){
  #load empty table for results+ define rcount parameter
output <- data.frame(read_excel("Z:/Ligal/Ligal  - MyDocs/data for R practice/output.xlsx"))
#load raw data
my_data<-shared_seq
#naming the colums 
my_data_colums<- c("seq","n.of targets","V hit","D hit",
                   "J hit","Isotype","V aligment",
                   "D aligment","J aligment","C aligment","N FR1","N CDR1","N FR2","N CDR2","N FR3","CDR3","N FR4",
                   "AA FR1","AA CDR1","AA FR2","AA CDR2","AA FR3","AA CDR3","AA FR4")
colnames(my_data) <- my_data_colums

#start loop for random sampling and diversity measurment
rcount<-1000
i<-1
while(rcount < nrow(my_data)){
  #random sampling
  my_sample<-my_data[sample(nrow(my_data), rcount), ]
  #display uniqe seq only , than count them
  uniqe_seq_df<-data.frame(distinct(my_sample,seq,.keep_all=T))
  no_uniqe_seq<-nrow(uniqe_seq_df)
  #print to console
  print(c(rcount,no_uniqe_seq))
  #assign results to pre-loaded matrix
  output[i,2]<-no_uniqe_seq
  output[i,1]<-rcount
  #loop counting
  rcount<- rcount+1000
  i<-i+1}
list_output<-list(output)
return(list_output)
}
#use function- here you need to insert shared seq file and working directory
list1<- RareFaction(shared_seq,"~/My Desktop/Hammpers project")
#unlist
rarefaction_df<-list1[[1]]

#add names
names(rarefaction_df)<- c("Number_of_sequences","Diversity")
#add prop
rarefaction_df$V1<- prop.table(rarefaction_df$Number_of_sequences) 
rarefaction_df$V2<- prop.table(rarefaction_df$Diversity) 

#plot graph### optional###
library(ggplot2)
ggplot(data=rarefaction_df, aes(x=Number_of_sequences ,y=Diversity))+geom_smooth(color="black")+ggtitle("Rarefaction")+
  theme_minimal()+ theme(axis.text=element_text(size = 10),
                         axis.title = element_text(size=12, face = "bold", color = "black"),
                         plot.title = element_text(size=15, face = "bold", hjust = 0.5, color = "black"))

#export RF results
library(openxlsx)
write.xlsx(rarefaction_df, "Rare fraction.xlsx")
