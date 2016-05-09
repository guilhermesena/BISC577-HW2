##### Question 4 #####

library(DNAshapeR)
library(caret)

makeSummary <- function (in_file, shape) {
    
    # Makes prediction shape for FASTA sequence
    fn <- paste("in/",in_file,".txt.fa", sep="")
    pred <- getShape(fn)
    
    # Encodes the sequence shape
    features <- c("1-mer")
    if(shape) {
        features <- c(features, "1-shape")
    }
    featureVector <- encodeSeqShape(fn, pred, features)
    
    # Reads fragment lengths
    exp_data <- read.table(paste("in/",in_file,".txt",sep=""))
    df <- data.frame(affinity=exp_data$V2, featureVector)
                
    # Trains the model with L2-regularization
    trainControl <- trainControl(method = "cv", number = 10, savePredictions = TRUE)
    model <- train (affinity~ ., data = df, trControl=trainControl, 
                method = "glmnet", tuneGrid = data.frame(alpha = 0, lambda = c(2^c(-15:15))))
    
    # gets the best R-square average
    return (max(model$results$Rsquared, na.rm = T))
}

experiments <- c("Mad", "Max", "Myc")
for (name in experiments) {
    for(shape in c(TRUE, FALSE)) {
            print(paste("R2 for ", name, "with shape = ", shape, "is ",makeSummary(name, shape)))
        }
}
