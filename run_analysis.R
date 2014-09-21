#Load necessary packages from the library

#library("data.table")
library("reshape2")

#Load the files from the directory in to R Studio

#features <- read.csv("features.csv", header = F, stringsAsFactors = FALSE)
features <- read.csv("features2.csv", header = F, stringsAsFactors = FALSE)
features <- features[,"V2"]
fnames <- as.list(t(features))
labels <- read.csv("activity_labels.csv", header = F)
subject_test <- read.csv("subject_test.csv", header = F)
subject_train <- read.csv("subject_train.csv", header = F)
X_test <- read.csv("X_test.csv", header = F)
X_train <- read.csv("X_train.csv", header = F)
Y_test <- read.csv("y_test.csv", header = F)
Y_train <- read.csv("y_train.csv", header = F)

#assign column names to the data files

#colnames(X_test) <- features
colnames(X_test) <- fnames
colnames(Y_test) <- "activity_type"
colnames(X_train) <- features
colnames(Y_train) <- "activity_type"
colnames(subject_test) <- "subject_id"
colnames(subject_train) <-"subject_id"

#Merging data files

train_data <- cbind(X_train, subject_train, Y_train)
test_data <- cbind(X_test, subject_test, Y_test)

#Merging training and test data sets

mega_data <- rbind(train_data, test_data)

#Subsetting the data for a tidy data set
mega_data_cols <- grepl("(mean|std|activity|subject)", names(mega_data))
mega_data_seq <- seq(1, ncol(mega_data))
mega_data_sub <- mega_data[, mega_data_seq[mega_data_cols]]

# Getting the means of the tidy data set
melt_data  <- melt(mega_data_sub, id.vars = c("subject_id", "activity_type"))
tidy_data  <- dcast(melt_data, activity_type + subject_id ~ variable, mean)
#tidy_data <- by(melt_data$activity_type, melt_data$subject_id, melt_data$variable, mean(melt_data$value))
#tidy_data <- by(melt_data$activity_type, melt_data$subject_id, melt_data$variable, summary)

#Creating the tidy data set
write.table(tidy_data, 'tidy_data.txt', row.names=FALSE)

