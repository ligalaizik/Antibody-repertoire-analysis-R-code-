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
SharedSeq<- function(textfile1,textfile2,WorkingDirectory) {
  setwd(WorkingDirectory)
  my_raw_data <- read_delim(textfile1, "\t", escape_double = FALSE, trim_ws = TRUE)
  my_raw_data2<- read_delim(textfile2,  "\t", escape_double = FALSE, trim_ws = TRUE)
  
  #names vector
  my_data_colums<- c("seq","n.of targets","V hit","D hit",
                     "J hit","Isotype","V aligment",
                     "D aligment","J aligment","C aligment",
                     "N FR1","N CDR1","N FR2","N CDR2","N FR3","CDR3",
                     "N FR4","AA FR1","AA CDR1","AA FR2","AA CDR2",
                     "AA FR3","AA CDR3","AA FR4")
  
  #naming the colums 
  colnames(my_raw_data) <- my_data_colums
  colnames(my_raw_data2) <- my_data_colums
  
  #filter-out empty seq
  my_data<-my_raw_data %>% filter_all(all_vars(!is.na(my_raw_data$seq)))
  my_data2<-my_raw_data2 %>% filter_all(all_vars(!is.na(my_raw_data2$seq)))
  #remove last N from FR4 (not V region)
  my_data$`N FR4`<- str_sub(my_data$`N FR4`,1,30)
  my_data2$`N FR4`<- str_sub(my_data2$`N FR4`,1,30)
  #replace seq colum with FR1:FR4 combination
  my_data$seq<-gsub(" ", "", paste(my_data$`N FR1`,my_data$`N CDR1`,my_data$`N FR2`,my_data$`N CDR2`,my_data$`N FR3`,my_data$`CDR3`,my_data$`N FR4`))
  my_data2$seq<-gsub(" ", "", paste(my_data2$`N FR1`,my_data2$`N CDR1`,my_data2$`N FR2`,my_data2$`N CDR2`,my_data2$`N FR3`,my_data2$`CDR3`,my_data2$`N FR4`))
  
  #remove seq with length<300
  my_data<-subset(my_data,nchar(seq)>300)
  my_data2<-subset(my_data2,nchar(seq)>300)
  
  #filter out AA seq with stop codon (*)
  my_data$AA_seq<-translate(my_data$seq)
  my_data<- subset(my_data, str_detect(my_data$AA_seq, fixed("*"),negate=TRUE) == TRUE) 
  my_data2$AA_seq<-translate(my_data2$seq)
  my_data2<- subset(my_data2, str_detect(my_data2$AA_seq, fixed("*"),negate=TRUE) == TRUE) 
  
  
  #delete AA seq
  my_data$AA_seq<- NULL
  my_data2$AA_seq<- NULL
  
  #clustring seq and counting
  output<-ddply(my_data,.(seq),nrow)
  output2<-ddply(my_data2,.(seq),nrow)
  
  #find shared sequnces   
  shared_seq<-merge.data.frame(output, output2, by= 'seq')
  
  #remove double singletones 
  merged_filtered_df<- subset(shared_seq,shared_seq$V1.x!= 1 | shared_seq$V1.y !=1)
  
  #merge aligned duplicates into single table
  aligned_data_merged<-rbind.data.frame(my_data,my_data2)
  
  #subset aligned data by shared and filtered sequences 
  newdata<- subset(aligned_data_merged, seq %in% merged_filtered_df$seq)
  
  #create list to export
  list_output<-list(newdata,shared_seq,nrow(my_data),nrow(my_data2),nrow(output),nrow(output2),nrow(shared_seq),nrow(merged_filtered_df))
   return(list_output)
}

#use function - here you need to insert 2 txt files and workind directory  
list1<-SharedSeq("output_align_250.txt","output_align_251.txt","Z:/MiSeq/08-11-20/YAEL05112020-208545337/FASTQ_Generation_2020-11-07_18_09_55Z-339077754/250-251") 
#unlist tables
shared_seq<- list1[[1]]
duplicates_correlation<- list1[[2]]
productive_reads_rep1<-list1[[3]]
productive_reads_rep2<-list1[[4]]
uniqe_seq_rep1<-list1[[5]]
uniqe_seq_rep2<-list1[[6]]
exist_in_both<-list1[[7]]
seq_without_double_singlets<-list1[[8]]
#export data to excel
write.xlsx(shared_seq,"shared seq.xlsx")
write.xlsx(duplicates_correlation,"duplicates correlation.xlsx")

