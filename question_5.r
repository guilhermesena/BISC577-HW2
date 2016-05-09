##### Question 5 #####
library(coin)
library(stats)

# I wrote the previous rsq values on a txt file
rsq <- read.table("in/rsq.txt")

# Plot the values
plot(as.numeric(rsq[1,]), as.numeric(rsq[2,]), xlab = "1-mer", ylab = "1-mer+shape", 
     col=c("red","green","blue"), pch=15:17)

#Wilcox's rank sum test
wilcox.test(as.numeric(rsq[1,]), as.numeric(rsq[2,]), paired=FALSE, alternative="greater")
