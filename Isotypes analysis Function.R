library(openxlsx)
library(readxl)
library(plyr)
library(data.table)

#function- ## here you dont need to change anything##
Isotypes<- function(uniqe_shared_seq,WorkingDirectory){
  df<-uniqe_shared_seq
#clustring Isotypes and count
data<-ddply(df,.(Isotype),nrow)
#sort from large to small
setorder(data,-V1)
#create list
list_output<- list(data)
return(list_output)
}
#use function - here you need to insert uniqe shared seq file and working directory
list1<- Isotypes(uniqe_shared_seq,"~/My Desktop/Hammpers project")
#unlist
isotypes_data<- list1[[1]]
##export df
write.xlsx(isotypes_data,"Isotype distribution.xlsx")

