require(data.table)
setwd('/Users/home/Documents/Workspace/R/992Alphabet')

A <- fread("a.csv", verbose=F, skip=1, colClasses = rep("c",28))
B <- fread("b.csv", verbose=F, skip=1, colClasses = rep("c",28))
C <- fread("c.csv", verbose=F, skip=1, colClasses = rep("c",28))
D <- fread("d.csv", verbose=F, skip=1, colClasses = rep("c",28))
EFG <- fread("efg.csv", verbose=F, skip=1, colClasses = rep("c",28))
HIJ <- fread("hij.csv", verbose=F, skip=1, colClasses = rep("c",28))
KL <- fread("kl.csv", verbose=F, skip=1, colClasses = rep("c",28))
MN <- fread("mn.csv", verbose=F, skip=1, colClasses = rep("c",28))
OPQ <- fread("opq.csv", verbose=F, skip=1, colClasses = rep("c",28))
R <- fread("r.csv", verbose=F, skip=1, colClasses = rep("c",28))
S <- fread("s.csv", verbose=F, skip=1, colClasses = rep("c",28))
TUVWX <- fread("tuvwx.csv", verbose=F, skip=1, colClasses = rep("c",28))
YZ <- fread("yz.csv", verbose=F, skip=1, colClasses = rep("c",28))
setkey(A, npi)
setkey(B, npi)
setkey(C, npi)
setkey(D, npi)
setkey(EFG, npi)
setkey(HIJ, npi)
setkey(KL, npi)
setkey(MN, npi)
setkey(OPQ, npi)
setkey(R, npi)
setkey(S, npi)
setkey(TUVWX, npi)
setkey(YZ, npi)

Detailed_Data <- rbind(A,B,C,D,EFG,HIJ,KL,MN,OPQ,R,S,TUVWX,YZ)
setkey(Detailed_Data, npi)

tmp <- Detailed_Data[provider_type == "Cardiology"]
Midwest <- c("ND","SD","NE","KS","MN","IA","MO","WI","IL","MI","IN","OH")
Detailed_Midwest <- tmp[nppes_provider_state %in% Midwest]
setkey(Detailed_Midwest, npi)

# HEAD <- c(rep("character",3), rep("factor",4), rep("character",4), rep("factor",5),	rep("character",2), "factor", rep("numeric",9))
require(dplyr)
Dataframe_Midwest <- as.data.frame(Detailed_Midwest)

for (i in c(23:28)) {
  tmp <- gsub(patter="\\$", replacement="", x = Dataframe_Midwest[,i])
  Dataframe_Midwest[,i] <- tmp
}
for (i in c(20:28)) {
  tmp <- gsub(patter=",", replacement="", x = Dataframe_Midwest[,i])
  Dataframe_Midwest[,i] <- as.numeric(tmp)
}

for (i in c(4:7,12:16,19)) {
  Dataframe_Midwest[,i] <- as.factor(Dataframe_Midwest[,i])
}

tmp <- gsub(pattern = "(\\d{5})(\\d*)", replacement = "\\1", x = Dataframe_Midwest$nppes_provider_zip)
Dataframe_Midwest$nppes_provider_zip <- tmp

colnames(Dataframe_Midwest)[1] <- "NPI"

Midwest <- as.data.table(Dataframe_Midwest)
setkey(Midwest, NPI)
