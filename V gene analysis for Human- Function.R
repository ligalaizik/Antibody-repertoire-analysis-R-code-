###V gene usage###
library(openxlsx)
library(readxl)
library(plyr)
library(stringr)

#function## here you dont need to change anything##
VgeneUsage<- function(uniqe_shared_seq,WorkingDirectory){
df<- uniqe_shared_seq
#clustring V genes and count
output<-ddply(df,.(`V hit`),nrow)
#remove *00 from v gene
output$`V hit`= substr(output$`V hit`,1,nchar(output$`V hit`)-3)

############################################
##complete table with all v gene from IMGT##
###########################################

#load IMGT table
all_V_genes<- read_excel(
  "Z:/Ligal/Ligal  - MyDocs/data for R practice/V genes IMGT for Human.xlsx")
all_V_genes<- data.frame(all_V_genes)
#start loop

for (i in 1:nrow(all_V_genes)){
  x<-str_detect(output$`V hit`,as.character(all_V_genes[i,1]))#search for the first elemnt of IMGT list in the output table
  location<-match(TRUE,x)#assign the location of the element to variable
  if (is.na(location)==TRUE){ #if the location is na- there is no match, put 0
    all_V_genes[i,2]<-"0" 
  } else {
    all_V_genes[i,2]<- output[as.numeric(location),2] #if there is a match, put the count of this location
  }
}   
names(all_V_genes)<- c("V hit","count")
#calculate freq 
sum(as.numeric(all_V_genes$count))
all_V_genes$frequency	<-prop.table(as.numeric(all_V_genes$count))

#superfamily
i<-1
for (i in i:nrow(all_V_genes)){
  superfamily<-qdapRegex::ex_between(all_V_genes[i,1], c("H", "H"), c("-", "S"))[[1]]
  all_V_genes[i,4]<-as.character(superfamily)
  i+1
}
list_output<-list(all_V_genes)
return(list_output)
}
#use function- here you need to insert uniqe shared seq file and working directory
list1<-VgeneUsage(uniqe_shared_seq,"~/My Desktop/Hammpers project")
#unlist
V_gene<-list1[[1]]

##export df
write.xlsx(V_gene,"V gene usage.xlsx")
