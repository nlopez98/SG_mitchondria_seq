#!/usr/bin/Rscript
library(stringr)
library(ggplot2)
library(tools)
#file_list = list.files(path = getwd(), pattern = "*.txt")
args = commandArgs(trailingOnly=TRUE)
#data_list <- vector("list", "length" = length(file_list))
#for (i in seq_along(file_list)) {
sample_id <- args[1]
all <- args[2]
nosecsupp <- args[3]
nameVector <- c(all,nosecsupp)
for (file in nameVector){
d <- read.csv(file, header = FALSE, col.names = c("Length", "Count"))
d <- str_split_fixed(d$Length, "\t", 2)
d <- as.data.frame(d)
colnames(d) <- c("Length", "Count")
d <- data.frame(apply(d, 2, function(x) as.numeric(as.character(x))))

write.csv(d, paste0("", file_path_sans_ext(file), ".csv"))
if(as.numeric(str_extract(sample_id, "[[:digit:]]+"))>1004) { #if barcode is 1008,1009,1010 = mito Sequence, make the last bin be 0.5*mito DNA length until the max
#par(mfrow=c(1,2))
png(paste0(file_path_sans_ext(file), "_histogram.png"))
d <- as.data.frame(d)
d1 <- subset(d, Length <34000) #remove anything longer than mito DNA length
hist <- hist(d1$Length, breaks = c(0,1700, 3400, 5100, 6800, 8500, 10200, 11900, 13600, 15300, 17000, 
max(d1$Length)), xlab = "Read Length", main = "Histogram of Read Lengths", freq = TRUE, labels=TRUE, cex = 0.8)
abline(v = round(sum(d$Length*d$Count)/sum(d$Count),3),
    col = "blue",
    lwd = 2)
legend("topright", paste0("Avg Read Len =", round(sum(d$Length*d$Count)/sum(d$Count),3)), fill = c("blue"), cex = 0.8)
hist$counts =log2(hist$counts+1) #log-frequency
hist$counts = round(hist$counts,2)
png(paste0(file_path_sans_ext(file), "_histogram_log.png"))
plot(hist, xlab = "Read Length", main = "Histogram of Read Lengths", freq = TRUE, labels=TRUE)
                abline(v = round(sum(d$Length*d$Count)/sum(d$Count),3),
                       col = "blue",
                       lwd = 2)
                legend("topright", cex = 0.8, paste0("Avg Read Len =", round(sum(d$Length*d$Count)/sum(d$Count),3)), fill = c("blue"))
} else { #if not a relevant barcode, just divide into 10 chunks
#par(mfrow=c(1,2))
png(paste0(file_path_sans_ext(file), "_histogram.png"))
d <- as.data.frame(d)
d1 <- subset(d, Length <34000) #remove anything longer than mito DNA length
hist <- hist(d1$Length, breaks = c(0,0.1*max(d1$Length), 0.2*max(d1$Length), 0.3*max(d1$Length), 0.4*max(d1$Length),
0.5*max(d1$Length), 0.6*max(d1$Length), 0.7*max(d1$Length), 0.8*max(d1$Length),0.9*max(d1$Length), max(d1$Length)), 
xlab = "Read Length", main = "Histogram of Read Lengths", freq = TRUE, labels=TRUE)
abline(v = sum(d$Length*d$Count)/sum(d$Count),
    col = "blue",
    lwd = 2)
legend("topright", paste0("Avg Read Len =", round(sum(d$Length*d$Count)/sum(d$Count),3)), fill = c("blue"))
hist$counts =log2(hist$counts+1) #log-frequency
hist$counts = round(hist$counts,2)
png(paste0(file_path_sans_ext(file), "_histogram_log.png"))
plot(hist, xlab = "Read Length", main = "Histogram of Read Lengths", freq = TRUE, labels=TRUE)
                abline(v = round(sum(d$Length*d$Count)/sum(d$Count),3),
                       col = "blue",
                       lwd = 2)
                legend("topright", cex = 0.8, paste0("Avg Read Len =", round(sum(d$Length*d$Count)/sum(d$Count),3)), fill = c("blue"))
}

}


