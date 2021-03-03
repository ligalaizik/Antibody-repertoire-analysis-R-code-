library(tidyverse)
  library(sjmisc)
  library(stringdist)
  library(plyr)
  library(dplyr)
  library(openxlsx)
  library(readr)
  library(stringr)

#functions
##create shared sequences function ## here you dont need to change anything##
UniqeSharedSeq<- function(shared_seq,WorkingDirectory) {
  
  setwd(WorkingDirectory)
  df<-shared_seq
  df<-df[1:17]
  df$`n.of targets`<- NULL
  df$`C aligment`<- NULL
  
  ##start with uniqe shared seq, always make sure that colum 6 is the########## 
  ###V alignet column, and shared seq is 15 colums total ##################################################
  
  ##find uniqe seq
  uniqe_seq_list<- ddply(df,.(seq),nrow)
  
  #find identical seq with diffrent V aligments 
  for (i in 1:nrow(uniqe_seq_list)){
    subset_df <- df %>% filter(df$seq == uniqe_seq_list[i,1])
    if (nrow(subset_df)>1){
      #extract data between 2 boundries
      for (j in 1:nrow(subset_df)){
        #add V scores
        subset_df[j,16]<-str_sub(subset_df[j,6], start = -6, end = -3)
        #add D scores
        subset_df[j,17]<-str_sub(subset_df[j,7], start = -5, end = -3)
        #add J scores
        subset_df[j,18]<-str_sub(subset_df[j,8], start = -5, end = -3)
      }
      colnames(subset_df)<-c("seq","V hit","D hit","J hit","Isotype","V aligment","D aligment","J aligment","N FR1","N CDR1","N FR2","N CDR2","N FR3","CDR3","N FR4","Vscore","Dscore","Jscore")
      #for V
      chosen_V_align<- subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),6] 
      chosen_V_hit<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),2]
      chosen_FR1<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),9]
      chosen_CDR1<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),10]
      chosen_FR2<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),11]
      chosen_CDR2<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),12]
      chosen_FR3<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),13]
      chosen_CDR3<-subset_df[which(subset_df$Vscore ==max(subset_df$Vscore)),14]
      
      seq_of_interest<-c(subset_df[1,1])
      
      df[which(df$seq==seq_of_interest),6]<-paste(chosen_V_align[1])
      df[which(df$seq==seq_of_interest),2]<-paste(chosen_V_hit[1])
      df[which(df$seq==seq_of_interest),9]<-paste(chosen_FR1[1])
      df[which(df$seq==seq_of_interest),10]<-paste(chosen_CDR1[1])
      df[which(df$seq==seq_of_interest),11]<-paste(chosen_FR2[1])
      df[which(df$seq==seq_of_interest),12]<-paste(chosen_CDR2[1])
      df[which(df$seq==seq_of_interest),13]<-paste(chosen_FR3[1])
      df[which(df$seq==seq_of_interest),14]<-paste(chosen_CDR3[1])
      
      #for D
      chosen_D_align<- subset_df[which(subset_df$Dscore ==max(subset_df$Dscore)),7] 
      chosen_D_hit<-subset_df[which(subset_df$Dscore ==max(subset_df$Dscore)),3]
      seq_of_interest<-c(subset_df[1,1])
      df[which(df$seq==seq_of_interest),7]<-paste(chosen_D_align[1])
      df[which(df$seq==seq_of_interest),3]<-paste(chosen_D_hit[1])
      #for J
      chosen_J_align<- subset_df[which(subset_df$Jscore ==max(subset_df$Jscore)),8] 
      chosen_J_hit<-subset_df[which(subset_df$Jscore ==max(subset_df$Jscore)),4]
      seq_of_interest<-c(subset_df[1,1])
      df[which(df$seq==seq_of_interest),8]<-paste(chosen_J_align[1])
      df[which(df$seq==seq_of_interest),4]<-paste(chosen_J_hit[1])
    }
  }
  
  #create new uniqe table 
  uniqe_df<-ddply(df,.(seq,`V hit`,`D hit`,`J hit`,Isotype,`V aligment`,`D aligment`,`J aligment`,`N FR1`,`N CDR1`,`N FR2`,`N CDR2`,`N FR3`,CDR3,`N FR4`),nrow)
  colnames(uniqe_df)<-c("seq","V hit","D hit","J hit","Isotype","V aligment","D aligment","J aligment","N FR1","N CDR1","N FR2","N CDR2","N FR3","CDR3","N FR4","No_transcripts")
  
  #create list to export
  list_output<-list(uniqe_df)
  return(list_output)
}
#use function - here you need to insert shared seq file and working directory
list1<-UniqeSharedSeq(shared_seq,"~/My Desktop/Hammpers project") 
#unlist tables
uniqe_shared_seq<-list1[[1]]
#export
write.xlsx(uniqe_shared_seq,"uniqe shared seq.xlsx")
