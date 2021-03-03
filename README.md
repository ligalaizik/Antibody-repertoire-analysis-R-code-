# Antibody-repertoire-analysis-R-code-

This repository include R code scripts for the analysis of NGS data for the heavy chain variaible region of antibodies. The output files obtained from MiXCR initial analysis will be used as an input for the following analysis
The command lines for MiXCR analysis is as follows:

#paired-end alignment and aligment to IMGT DB

Windows

java -Xmx4g -Xms3g -jar mixcr.jar align -s [hs - for human, ms -for mouse) -r [add report file name] -g [add fastq R1 file name] [add fastq R2 file name] [add output filename with .vdjca format]

Mac OsX

mixcr align -s [hs - for human, ms -for mouse) -r [add report file name] -g [add fastq R1 file name] [add fastq R2 file name] [add output filename with .vdjca format]



#export aligments

Windows

java -Xmx4g -Xms3g -jar mixcr.jar exportAlignments -f -nFeature {FR1Begin:FR4End} -targets -vHit -dHit -jHit -cHit -vAlignment -dAlignment -jAlignment -cAlignments -nFeature FR1 -nFeature CDR1 -nFeature FR2 -nFeature CDR2 -nFeature FR3 -nFeature CDR3 -nFeature FR4    -aaFeature FR1 -aaFeature CDR1 -aaFeature FR2 -aaFeature CDR2 -aaFeature FR3 -aaFeature CDR3 -aaFeature FR4    [enter .vdjca file name]  [enter output file name .txt format]

Mac OsX

mixcr exportAlignments -f -nFeature {FR1Begin:FR4End} -targets -vHit -dHit -jHit -cHit -vAlignment -dAlignment -jAlignment -cAlignments -nFeature FR1 -nFeature CDR1 -nFeature FR2 -nFeature CDR2 -nFeature FR3 -nFeature CDR3 -nFeature FR4    -aaFeature FR1 -aaFeature CDR1 -aaFeature FR2 -aaFeature CDR2 -aaFeature FR3 -aaFeature CDR3 -aaFeature FR4    [enter .vdjca file name]  [enter output file name .txt format]



The output file from each MiXCR run will be used as an input for the R scripts

R scripts include the following:
1/ 
