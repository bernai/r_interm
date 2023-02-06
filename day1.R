# 01 SELECT
setwd("~/Documents/uni/FS23/R") # set working directory
library(data.table) # import data.table for fread
library(lubridate) # for date formatting (as_datetime)

data = fread("transactions.csv") # read in data

summary(data) # see stats
str(data) # see types and how many observations

data[, TransDate:=dmy(TransDate)] # format dates correctly
# data[,TransDate=as_date(TransDate, format="%d.%m.%y")]
str(data) # check if data formatted correctly as date

# Select only the rows with a purchase amount greater than 100 and lower than 200,
# and only the columns Customer and Cost
data[PurchAmount > 100 & PurchAmount > 200, list(Customer, Cost)]

# 02 AGGREGATE
# Calculate the sum of purchase amount by customer and transaction date
data[, sum(PurchAmount), by=c("Customer", "TransDate")]

# Calculate the number of transactions of each customer
data[, Count := 1:.N, by=Customer]

# Create a new column in your data table and store, for each customer and
# transaction, the quantity purchased in the next transaction. Hint: You can do his by
# creating an aggregated lead shifting variable for the variable Quantity. Use an
# offset of 1 and aggregate the data by customer. You can name the resulting column
# LeadQuantity

data[, LeadQuantity := shift(Quantity), by=Customer]
max(data$LeadQuantity, na.rm=TRUE)

# or with the n
data[, LeadQuantity := shift(Quantity, 1), by=Customer]
max(data$LeadQuantity, na.rm=TRUE)

# 03 MERGE
demogr = fread("demographics.csv")
demogr[, Birthdate:=dmy(Birthdate)]
demogr[, JoinDate:=dmy(JoinDate)]

# Merge the tables transactions and demographics by the 
# column Customer using an outer left join.
merged_outer = merge(data, demogr, by="Customer")

# merge with inner join, only customers born after 1980
merged_inner = merge(data, demogr, by="Customer", all=FALSE)
merged_inner = merged_inner[merged_inner$Birthdate > "1980-01-01",]

# 04 CONDITIONS
setwd("~/Documents/uni/FS23/R") # set working directory
library(data.table) # import data.table for fread
library(lubridate) # for date formatting (as_datetime)

data = fread("transactions.csv") # read in data
data[, TransDate:=dmy(TransDate)]

sales = data[TransDate>="2012-11-09", sum(PurchAmount),] 

if (sales < 30000){
  print("offer 10% discount")
} else if (sales < 45000){
  print("free item for every 3 items bought")
} else {
  print("no campaign")
}

# 05 LOOPS
setwd("~/Documents/uni/FS23/R") # set working directory
library(data.table) # import data.table for fread
library(lubridate) # for date formatting (as_datetime)

data = fread("transactions.csv") # read in data
data[, TransDate:=dmy(TransDate)]

# write loop that iterates over rows of table and stops when 
# cumulative sum of all transactions over 1 million
cum_sum = 0

for (i in 1:nrow(data)){
  cum_sum = cum_sum + data[i,]$PurchAmount
  if (cum_sum > 1000000){
    print(data[i,]$TransDate)
    break
  }
}

# 06 FUNCTIONS
# function that divides two numbers
divide_vars_funct <- function(var1, var2){
  return(var1/var2)
} 

print(divide_vars_funct(6, 2))

# function that simulates two dice rolls and returns 
# sum of the rolls
two_dice_roll_funct <- function(proba=NULL){
  # replacement true because we want to be able to roll numbers twice
  dice_rolls = sample(1:6, 2, prob = proba, replace = TRUE) # sample 2 numbers from 1 to 6
  print(sprintf("The 1st roll is %1$d, the 2nd roll is %2$d", dice_rolls[1], dice_rolls[2]))
  return (sum(dice_rolls)) # return sum
}

# 75% of rolling 6 (rigged dice), 5% for the rest
two_dice_roll_funct(proba = c(0.05, 0.05, 0.05, 0.05, 0.05, 0.75)) 
# or alternatively to write quicker
two_dice_roll_funct(proba = c(rep(0.05, 5), 0.75))
