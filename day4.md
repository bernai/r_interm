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

## BENCHMARKING

```R
# PLACEHOLDER
```
