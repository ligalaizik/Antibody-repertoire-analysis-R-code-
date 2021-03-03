##### Load libraries and set the working directory ##### 
library(devtools)
library(readr)
library(Biostrings)
library(dplyr)
library(data.table)
library(stringr)
library(Rcpp)
library(readxl)
library(openxlsx)

#function- ## here you dont need to change anything##
MutationCount<-function(uniqe_shared_seq,WorkingDirectory){
  
 ##### Function ##### 
splitVcol <- function(sample_df){
  breaked=within(sample_df, breaked_Vali<-data.frame(do.call('rbind', strsplit(as.character(sample_df$`V aligment`), '|', fixed=T)),stringsAsFactors = F))
  sample_df$keeper_alignment=breaked$breaked_Vali$X6
  return(sample_df)
}
##load df
sample_df=uniqe_shared_seq
##extract string between 2 pipes
splitVcol_sample_df=(splitVcol(sample_df))
#count numbers >20 (=mutations that are not primers errorrs)
splitVcol_sample_df$count <- sapply(splitVcol_sample_df$keeper_alignment, function(v) length(Filter(function(x) as.numeric(x)>20,unlist(strsplit(v,"\\D")))))
#create list to export
list_output<-list(splitVcol_sample_df)
return(list_output)
}
#use function- here you need to insert uniqe shared seq file and working directory
list1<- MutationCount(uniqe_shared_seq,"~/My Desktop/Hammpers project")
#unlist
shared_seq_with_mut<-list1[[1]]
##export df
write.xlsx(shared_seq_with_mut,"uniqe shared seq with mutation.xlsx")
