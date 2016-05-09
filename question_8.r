##### Question 8 #####

library(DNAshapeR)
library(ROCR)
library(caret)
library(BSgenome.Mmusculus.UCSC.mm10)

plotROC <- function (in_file_unbounded, in_file_bounded, shape) {
    
    # First I make the input files
    fn_unbounded <- paste("in/",in_file_unbounded,".fa", sep="")
    fn_bounded <- paste("in/",in_file_bounded,".fa", sep="")
    fn_temp <- "in/ctcf.fa"
    
    # Then I read the strings and paste into a fasta file
    boundFasta <- readBStringSet(fn_bounded)
    unboundFasta <- readBStringSet(fn_unbounded)
    
    boundTxt <- cbind( sapply(1:length(boundFasta),
                           function(x) as.character(boundFasta[[x]])),
                    matrix(1, length(boundFasta), 1))
                               
    unboundTxt <- cbind( sapply(1:length(unboundFasta),
                             function(x) as.character(unboundFasta[[x]])),
                      matrix(0, length(unboundFasta), 1))

    writeXStringSet( c(boundFasta, unboundFasta), fn_temp )
   
    # Use the fasta file for DNA shape prediction
    shapePred <- getShape(fn_temp)

    # Encode feature vectors
    featureType <- c("1-mer")
    if(shape == TRUE) {
        featureType <- c(featureType, "1-shape")
    }
    featureVector <- encodeSeqShape(fn_temp, shapePred, featureType)
                                 
    # Makes DataFrame Matrix 
    exp_data_matrix <- rbind(boundTxt, unboundTxt)
    exp_data <- as.data.frame(exp_data_matrix)                                 
    exp_data$V2 <- ifelse(exp_data$V2 == 1 , "Y", "N")
    df <- data.frame(isBound = exp_data$V2, featureVector)
                                 
    # Set parameters for Caret
    trainControl <- trainControl(method = "cv", number = 2, 
                                 savePredictions = TRUE, classProbs = TRUE)
    # Perform prediction
    model <- train(isBound~ ., data = df, trControl = trainControl,
                   method = "glm", family = binomial, metric ="ROC")
                                 
    # Plot AUROC
    prediction <- prediction( model$pred$Y, model$pred$obs )
    performance <- performance( prediction, "tpr", "fpr" )
    plot(performance)

    # Caluculate AUROC
    auc <- performance(prediction, "auc")
    auc <- unlist(slot(auc, "y.values"))
    print(auc)
}
                                
plotROC("unbound", "bound", TRUE)
plotROC("unbound", "bound", FALSE)
