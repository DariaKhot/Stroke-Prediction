#installing library for class imbalance
library(ggplot2)
library(broom)
library(lattice)
library(caret)
library(ROSE)
library(tree)
library(caret)
library(class)
library(randomForest)
#Clearing data
rm(list = ls())
#Reading data in 
data=read.csv(file.choose(),header=T, stringsAsFactors=TRUE)

#understanding the data
head(data)
dim(data)
str(data)
summary(data)

#setting up
names(data)
attach(data)

#checking for duplicate values
sum(duplicated(data))

#checking for na values
sum(is.na(data))
colSums(data == "N/A")

#removing na values
data[data == "N/A"] <- NA
data <- na.omit(data)

#sanity check
sum(is.na(data))
colSums(data == "N/A")


#drop 3rd column in gender(other)
data$gender <- as.character(data$gender)
unique(data$gender)
data<- data[data$gender != "Other" & !is.na(data$gender), ]


# Bar Charts for stroke vs gender
stroke_counts <- table(data$gender, data$stroke)
barplot(stroke_counts, beside = TRUE, col = c("lightblue", "salmon"),
        main = "Comparison of Stroke Frequency by Gender",
        xlab = "Stroke", ylab = "Frequency")

# Creating the the legend position
legend("topright", legend = rownames(stroke_counts), fill = c("lightblue", "salmon"),
       x = "top", y = "right")



#dropping features due to being categorical
data <- data[ , !(names(data) %in% c("work_type", "smoking_status"))]


#Up sampling data
table(data$stroke)
data_upsampled <- ovun.sample(stroke ~ ., data = data, method = "over", N = 9000, seed = 1234)$data
str(data_upsampled)
table(data_upsampled$stroke)

# Bar Charts for stroke vs gender up sampled data
stroke_counts <- table(data_upsampled$gender, data_upsampled$stroke)
barplot(stroke_counts, beside = TRUE, col = c("lightblue", "salmon"),
        main = "Comparison of Stroke Frequency by Gender",
        xlab = "Stroke", ylab = "Frequency")

# Creating the the legend position
legend("topright", legend = rownames(stroke_counts), fill = c("lightblue", "salmon"),
       x = "top", y = "right")




#Converting gender, residence type, and ever_married to 1 and 2
data_upsampled$gender<- ifelse(data_upsampled$gender == "Male", 0, 1)
data_upsampled$Residence_type<- ifelse(data_upsampled$Residence_type == "Rural", 0, 1)
data_upsampled$ever_married<- ifelse(data_upsampled$ever_married == "No", 0, 1)

#correlation matrix of up sampled data
data_upsampled$bmi <- as.numeric(data_upsampled$bmi)
data_numeric <- data_upsampled[sapply(data_upsampled, is.numeric)]
correlation_matrix <- cor(data_numeric, method = "pearson")
print(correlation_matrix)
data_upsampled$bmi <- as.integer(data_upsampled$bmi)

#we will not use id in the model
#model 1

glm.fit1=glm(stroke~gender+age+hypertension+ever_married+heart_disease+Residence_type+avg_glucose_level+bmi,data= data_upsampled)
summary(glm.fit1)

#logistic regression and 5 fold cross-val
set.seed(1)
k=5
folds=sample(1:k,nrow(data_upsampled),replace=TRUE)
data_upsampled$folds = folds

accuracy=rep(0,k)
precision = rep(0, k)
recall = rep(0, k)
f1_score = rep(0, k)

for(i in 1:k)
{
  glm.fit2=glm(stroke~gender+age+hypertension+heart_disease+Residence_type+avg_glucose_level+bmi,family="binomial",data=data_upsampled[folds!=i,])
  data_upsampled.test=data_upsampled[folds==i, ]
  glm.probs2 =predict(glm.fit2,data_upsampled.test, type="response")
  glm.pred2=rep("0",nrow(data_upsampled[folds==i,]))
  glm.pred2[glm.probs2>.5]="1"
  
  #accuracy
  test.truevalue = data_upsampled[folds == i, "stroke"]
  table(glm.pred2,test.truevalue)
  accuracy[i]=mean(glm.pred2==test.truevalue)
  
  #confusion matrix
  cm = confusionMatrix(as.factor(glm.pred2), as.factor(test.truevalue))
  
  # Calculating precision, recall, and F1-score
  precision[i] = cm$byClass['Pos Pred Value']
  recall[i] = cm$byClass['Sensitivity']
  f1_score[i] = 2 * (precision[i] * recall[i]) / (precision[i] + recall[i])
}
mean(accuracy)
mean(precision)
mean(recall)
mean(f1_score)
print(cm)


#KNN
standardized.age=scale(data_upsampled$age)
standardized.avg_glucose_level=scale(data_upsampled$avg_glucose_level)
standardized.bmi=scale(data_upsampled$bmi)

Input.standard = data.frame(
  ever_married=data_upsampled$ever_married,
  gender = data_upsampled$gender,
  hypertension = data_upsampled$hypertension,
  heart_disease = data_upsampled$heart_disease,
  Residence_type = data_upsampled$Residence_type,
  standardized_age = standardized.age,
  standardized_avg_glucose_level = standardized.avg_glucose_level,
  standardized_bmi = standardized.bmi
)
accuracy=matrix(0,10,5)
precision = matrix(0, 10, 5)
recall = matrix(0, 10, 5)
f1_score = matrix(0, 10, 5)

for (j in 1:10)
{
  for(i in 1:5)
  {
    train.standard=Input.standard[data_upsampled$folds!=i,]
    test.standard=Input.standard[data_upsampled$folds==i,]
    train.truevalue=data_upsampled[data_upsampled$folds!=i, "stroke"]
    test.truevalue=data_upsampled[data_upsampled$folds == i, "stroke"]
    knn.pred=knn(train.standard,test.standard,train.truevalue,k=j)
    accuracy[j,i]=mean(knn.pred==test.truevalue)
    cm = confusionMatrix(as.factor(knn.pred), as.factor(test.truevalue))
    precision[j, i] = cm$byClass['Pos Pred Value']
    recall[j, i] = cm$byClass['Sensitivity']
    f1_score[j, i] = 2 * (precision[j, i] * recall[j, i]) / (precision[j, i] + recall[j, i])
  }
}
cv.accuracy=apply(accuracy,1,mean)
cv_precision = apply(precision, 1, mean, na.rm = TRUE)
cv_recall = apply(recall, 1, mean, na.rm = TRUE)
cv_f1_score = apply(f1_score, 1, mean, na.rm = TRUE)
mean(cv.accuracy)
mean(cv_precision)
mean(cv_recall)
mean(cv_f1_score)
print(cm)

#decision tree
data_upsampled$stroke <- as.factor(data_upsampled$stroke)

train=sample(nrow(data_upsampled),nrow(data_upsampled)*0.8)
tree.model=tree(stroke~gender+age+ever_married+hypertension+heart_disease+Residence_type+avg_glucose_level+bmi,data_upsampled,subset =train)
data_upsampled.test=data_upsampled[-train,]
stroke.test = data_upsampled.test$stroke

cv.model=cv.tree(tree.model,k=5,FUN=prune.misclass)
cv.model

#plot
prune.model=prune.tree(tree.model,best=5)
plot(prune.model)
text(prune.model,pretty=0)

prunetree.pred=predict(prune.model,data_upsampled.test,type="class")
table(prunetree.pred,stroke.test)

#metrics and cm
accuracy=mean(prunetree.pred == stroke.test)
print(paste("Accuracy:", accuracy))
precision = cm$byClass['Pos Pred Value']
print(paste("Precision:", precision))
recall = cm$byClass['Sensitivity']
print(paste("Recall:", recall))
f1_score = 2 * (precision * recall) / (precision + recall)
print(paste("F1-Score:", f1_score))

cm = confusionMatrix(as.factor(prunetree.pred), as.factor(stroke.test))
print(cm)

#random forest(best result)
rf_model=randomForest(stroke~gender+age+ever_married+hypertension+heart_disease+Residence_type+avg_glucose_level+bmi,data=data_upsampled,subset=train,mtry=7,importance=TRUE)
prunetree.pred=predict(rf_model,data_upsampled.test,type="class")
table(prunetree.pred,stroke.test)

#metrics and cm
accuracy=mean(prunetree.pred == stroke.test)
print(paste("Accuracy:", accuracy))
precision = cm$byClass['Pos Pred Value']
print(paste("Precision:", precision))
recall = cm$byClass['Sensitivity']
print(paste("Recall:", recall))
f1_score = 2 * (precision * recall) / (precision + recall)
print(paste("F1-Score:", f1_score))


#plot
var_imp <- importance(rf_model)
sorted_imp <- var_imp[order(var_imp[, "MeanDecreaseGini"], decreasing = TRUE), ]
barplot(sorted_imp[, "MeanDecreaseGini"], 
        main = "Variable Importance", 
        xlab = "Variables", 
        ylab = "Importance", 
        las = 2)


#data visualizations with the top three important variables in determining stroke
ggplot(data_upsampled, aes(x = age, fill = as.factor(stroke))) +
  geom_histogram(position = "dodge", bins = 30) +
  labs(x = "Age", y = "Count", fill = "Stroke", title = "Histogram of Age by Stroke Category")


ggplot(data_upsampled, aes(x = avg_glucose_level, fill = as.factor(stroke))) +
  geom_histogram(position = "dodge", bins = 30) +
  labs(x = "Average Glucose Level", y = "Count", fill = "Stroke", title = "Histogram of Average Glucose Level by Stroke Category")

ggplot(data_upsampled, aes(x = bmi, fill = as.factor(stroke))) +
  geom_histogram(position = "dodge", bins = 30) +
  labs(x = "BMI", y = "Count", fill = "Stroke", title = "Histogram of BMI by Stroke Category")



