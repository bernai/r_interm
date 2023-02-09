# Day 4

## 26 Profiling

### Profvis
Wrap code around this:
```R
library(profvis)

profvis({
# CODE
})
```

For example:
```R
library(Hmisc)
library(data.table)
library(lubridate)
data = fread("transactions.csv")
data[, TransDate:=dmy(TransDate)]

# see efficiency with profvis
library(profvis)
profvis({
weight_recency=1
weight_frequency=1
weight_monetary=1
  
# adjusting values to ensure that the weights add up to one 
weight_recency2 <- weight_recency/sum(weight_recency, weight_frequency, weight_monetary)
weight_frequency2 <- weight_frequency/sum(weight_recency, weight_frequency, weight_monetary)
weight_monetary2 <- weight_monetary/sum(weight_recency, weight_frequency, weight_monetary)

print("weights are calculated")

# RFM measures
max.Date <- max(data$TransDate)

temp <- data[,list(
  recency = as.numeric(max.Date - max(TransDate)),
  frequency = .N,
  monetary = mean(PurchAmount)),
  by=Customer
]

print("RFM Measure done")

# RFM scores
temp <- temp[,list(Customer,
                   recency = as.numeric(cut2(-recency, g=3)),
                   frequency = as.numeric(cut2(frequency, g=3)),
                   monetary = as.numeric(cut2(monetary, g=3)))]

# Overall RFM score
temp[,finalscore:=weight_recency2*recency+weight_frequency2*frequency+weight_monetary2*monetary]  

print("Overall RFM Measure done")

# RFM group
temp[,group:=round(finalscore)]

# Return final table
print(temp)

})

```

### Rprof
Wrap code around this: 
```R
Rprof("PATH TO OUTFILE") # saves results to following file
# CODE
Rprof()
summaryRprof("PATH TO OUTFILE") # shows summary of run that was saved in the file
```

For example:
```R
Rprof("~/Documents/uni/FS23/R/Exercises/Day4/profile.out")
RFMfunction(data)
Rprof()
summaryRprof("profile.out")
```

## 27 Benchmarking

```R
library(microbenchmark)

View(transactions)
# option 1
system.time(transactions[,sum(Quantity),by=Customer]) # 0.012s

# option 2
system.time(transactions[, relDate:= 1:.N, by=Customer]) # 0.031s

# or microbenchmark
microbenchmark(transactions[,sum(Quantity),by=Customer], 
               transactions[, relDate:= 1:.N, by=Customer]) # 12 ms mean vs 36ms 
```

# 28 How to do it better
```R
# some variables for the test
x = c(1, 2, 3, 4, 5)
table = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

# compare time of own version wit %in% vs match()
microbenchmark(table %in% x, match(x, table))
```

## 29 Just in time compilation

```R
library(compiler)

no_cmpfun = RFMfunction
with_cmpfun = cmpfun(RFMfunction)

enableJIT(3) # also compile nested functions (otherwise with cmpfun might even be slower)
microbenchmark(no_cmpfun(data), with_cmpfun(data), times=5L)
# no_cmpfun: mean 1.545 s
# with_cmpfun: mean 1.527 s
```

## Explicit parallelism

```R
library(doParallel)
library(foreach)

# make cluster with right amount of cores
cl = makeCluster(detectCores()-1)
registerDoParallel(cl)

# load data
setwd("~/Documents/uni/FS23/R/Exercises/Day4/")
data = fread("transactions.csv")
data[, TransDate:=dmy(TransDate)]

# weights for the 3 different runs
weights = list(c(1,1,1),c(60,20,20),c(20,20,60))

# 1:3 as there are 3 runs
res = foreach(i=1:3, .packages = c("Hmisc")) %dopar% {
  RFMfunction(data, weights[[i]])
  }
```
