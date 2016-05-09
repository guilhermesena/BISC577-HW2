##### Question 7 #####

library(DNAshapeR)

# FASTA file with 42k sequences of width 400 got in question 6
shape <- getShape("in/mmus.fa")

# Shape plots
plotShape(shape$MGW)
plotShape(shape$ProT)
plotShape(shape$Roll)
plotShape(shape$HelT)

# Heatmap plots for shape
heatShape(shape$MGW, 20)
heatShape(shape$ProT, 20)
heatShape(shape$Roll, 21)
heatShape(shape$HelT, 21)
