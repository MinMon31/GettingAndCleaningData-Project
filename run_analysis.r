#Fijar directorio de trabajo.
setwd("E:/Cursos/Especialización en Data Science/03. Getting and Cleaning Data/Sem 3/Proyecto")

####read all the datas####
#Test#
subjectTest<-read.table("test/subject_test.txt",header=FALSE)
xTest<-read.table("test/x_test.txt",header=FALSE)
yTest<-read.table("test/y_test.txt",header=FALSE)
#Train#
subjectTrain<-read.table("train/subject_train.txt",header=FALSE)
xTrain<-read.table("train/x_train.txt",header=FALSE)
yTrain<-read.table("train/y_train.txt",header=FALSE)
#activity labels
ActivityLabels<-read.table("activity_labels.txt",header=FALSE)
ActivityLabels[,2]<-as.character(ActivityLabels[,2])

#Features#
features<-read.table("features.txt",header=FALSE)

##Colum names to xtest##
colnames(xTest)<-features[,2]
colnames(xTrain)<-features[,2]


#Merge datas#
x<-rbind(xTest,xTrain)
y<-rbind(yTest,yTrain)
subject<-rbind(subjectTest,subjectTrain)

### Extract only the measurements on the mean and#### 
###standard deviation for each measurement#######.

# get only columns with mean() or std() in their names
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x <- x[, mean_std_features]

####Use descriptive activity names to name the activities in the data set###

# update values with correct activity names
library(data.table)

y[, 1] <- ActivityLabels[y[, 1], 2]
colnames(y)="Activity"

colnames(subject)="Subject"

Data<-cbind(x,y,subject)

Data.table=data.table(Data)


tidyData=aggregate(Data[,names(Data) != c('Activity','Subject')],by=list(Activity=Data$Activity,Subject = Data$Subject),mean)

write.table(tidyData, "tidyData.txt", row.name=FALSE)

write.csv(tidyData, "tidyData.csv")
