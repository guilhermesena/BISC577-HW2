##### Question 5 #####
library(coin)
library(stats)

# I wrote the previous rsq values on a txt file
rsq <- read.table("in/rsq.txt")
y_x <- seq(0.76, 0.87, 0.0001)
plot(y_x, y_x, xlab = "1-mer", ylab = "1-mer+shape",  type = "l")
points(rsq[1,], rsq[2,], pch=17:19, col=c("red", "green", "blue"))
legend(0.84, 0.78, c("Mad", "Max", "Myc"), pch = 17:19, col=c("red", "green", "blue"))


#Wilcox's rank sum test
wilcox.test(as.numeric(rsq[1,]), as.numeric(rsq[2,]), paired=FALSE, alternative="greater")
