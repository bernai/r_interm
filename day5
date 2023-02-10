## 01 Setup R and read in data

```R

setwd("~/Documents/uni/FS23/R/Exercises/Day5") # set working directory

library(data.table) # import data.table for fread
library(lubridate) # for date formatting (as_datetime)

data_cust = fread("data_customer.csv") # load data
data_pers = fread("data_personal.csv")
```

## 02 Prepare data for analysis

```R
# merge two data tables
data_merged = merge(data_cust, data_pers, by="CustomerId")

# save merged data table as csv
# fwrite(data_merged, "data_merged.csv")

# set Exited, Gender to factors
data_merged$Exited = as.factor(data_merged$Exited)
data_merged$Gender = as.factor(data_merged$Gender)


# check data
str(data_merged)
summary(data_merged)
```

## 03 Predict churn probability

```R
# create model
model = glm(Exited ~ CreditScore + Gender + Age + Tenure + Balance
            + NumOfProducts + HasCrCard + IsActiveMember + EstimatedSalary,
            family=binomial, data=data_merged)

# predict churn probability for each customer and add this as new column named "Exit"
data_merged$Exit = predict(model, type="response")

# print row of customer with highest/lowest churn probability
data_merged[Exit == max(Exit), list(CustomerId, Surname, Gender, Exit)][1] # modify columns if any other info is needed
data_merged[Exit == min(Exit), list(CustomerId, Surname, Gender, Exit)][1]

# avg churn probability for men and women
# option 1
data_women = data_merged[ Gender=="Female", list(CustomerId, Gender, Exit)] # 0 is female
data_men = data_merged[ Gender=="Male", list(CustomerId, Gender, Exit)] # 1 is male
mean(data_women$Exit)
mean(data_men$Exit)

# option 2
data_merged[,list(AVGChurn=mean(Exit)),by=Gender]
```

