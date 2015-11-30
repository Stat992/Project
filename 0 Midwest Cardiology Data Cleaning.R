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

tmp <- Detailed_Data[provider_type == "Cardiac Electrophysiology"]
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

Midwest_Cardiology <- Midwest
Midwest_Surgery <- Midwest
Midwest_Electrophysiology <- Midwest



###################################################################


# Row Bind the three Provider Types
Midwest <- rbind(Cardiology, Surgery, Electrophysiology)
# Calculate the Difference between Payments and Submitted Amounts
Midwest <- Midwest %>% mutate(Difference = average_submitted_chrg_amt - average_Medicare_payment_amt)
# Calculate the Mean and Standard Deviation of Difference For Each Procedure
# Midwest <- Midwest %>% filter(medicare_participation_indicator == "N")
tmp <- Midwest %>% group_by(hcpcs_code) %>% 
  summarize(Mean_Payment = mean(average_Medicare_payment_amt), 
            Mean_Submitted = mean(average_submitted_chrg_amt), 
            Mean_Allowed = mean(average_Medicare_allowed_amt), 
            Mean_Difference = mean(Difference), 
            SD_Difference = sd(Difference))
# Calculate Coefficient of Variation
tmp <- tmp %>% mutate(Coef_Variation = SD_Difference/Mean_Difference)
# Count the Number of Physicians in each Procedure
tmp <- left_join(tmp, count(Midwest,hcpcs_code), by="hcpcs_code")
# Attach the HCPCS Description to the table
Midwest$hcpcs_description <- as.factor(Midwest$hcpcs_description)
tmp2 <- Midwest %>% group_by(hcpcs_code) %>% summarize(Description = last(hcpcs_description))
tmp <- left_join(tmp, tmp2, by="hcpcs_code")
# Reorder the rows
tmp <- tmp %>% arrange(desc(Mean_Payment))

Cardiology <- Midwest_Cardiology
Electrophysiology <- Midwest_Electrophysiology
Surgery <- Midwest_Surgery
Summary <- tmp
Table <- Summary


### 33533 & 92928
Midwest <- rbind(Cardiology, Electrophysiology, Surgery)
Bypass <- Midwest[which(Midwest$hcpcs_code == 33533),]
Bypass <- Bypass %>% mutate(Difference = average_submitted_chrg_amt - average_Medicare_payment_amt)
Bypass <- Bypass %>% mutate(Differ_rate = Difference / average_submitted_chrg_amt)
Stent <- Midwest[which(Midwest$hcpcs_code == 92928),]
Stent <- Stent %>% mutate(Difference = average_submitted_chrg_amt - average_Medicare_payment_amt)
Stent <- Stent %>% mutate(Differ_rate = Difference / average_submitted_chrg_amt)


### 
completeBypass <-  merge(Bypass, Dat[which(Dat$NPI %in% Bypass$NPI), ],by = "NPI")
completeStent <-  merge(Stent, Dat[which(Dat$NPI %in% Stent$NPI), ], by = "NPI")
completeBypass <- as.data.frame(completeBypass)
completeStent <- as.data.frame(completeStent)
Pred <- rbind(completeBypass, completeStent)
Pred <- as.data.frame(Pred)
colnames(Pred)
# diff_rate <- c(1,6,12,21,30,38,39,40,58,63,64,86,89)

# Difference Rate
diff_rate <- c(6,12,21,23,30,38,39,40,58,63,64,73:88,89)
diff_rate <- completeStent[,diff_rate]
LM1 <- lm(Differ_rate~. , data=diff_rate)
summary(LM1)

# Submitted
diff_rate <- c(1,6,11,12,21,23,25,27,29,30,38:40,58,63:65,71,73:88,89)
diff_rate <- completeStent[,diff_rate]
summary(LM1)
summary(LM2)
summary(LM3)
colnames(diff_rate)
cor(diff_rate[,6:10])
Pred <- diff_rate
