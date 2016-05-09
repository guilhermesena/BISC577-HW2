##### Question 6 #####

library(AnnotationHub)
library(rtracklayer)
library(DNAshapeR)
library(BSgenome.Mmusculus.UCSC.mm10)
library(caret)
library(e1071)
library(ROCR)

ah <- AnnotationHub()

# Get AnnotationHub id for CTCF transcription factor of mm10
mmus <- ah[["AH28451"]]
seqlevelsStyle(mmus) <- "UCSC"

# Get sequences of length 400 and save it in the "in" directory
getFasta(mmus, BSgenome.Mmusculus.UCSC.mm10, width = 400, filename = "in/mmus.fa")
