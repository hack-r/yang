
# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop//yang")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, RDSTK, rvest, stringi, sqldf, XML, zipcode, zoo)

# Data --------------------------------------------------------------------
zs  <- readRDS("zs.RDS")
mls <- fread("yang_crmls.csv") 

data("zipcode")
zip     <- zipcode[zipcode$state == "CA",]

mls$city_code <- mls$City
mls$City      <- NULL

mls$city_code <- gsub("LONG","Long Beach",mls$city_code)
mls$city_code <- gsub("LA","Los Angeles",mls$city_code)
mls$city_code <- gsub("ALH","ALHAMBRA",mls$city_code)
mls$city_code <- gsub("ART","ARTESIA",mls$city_code)
mls$city_code <- gsub("BBK","BURBANK",mls$city_code)
mls$city_code <- gsub("BDPK","BERMUDA DUNES",mls$city_code)
mls$city_code <- gsub("BELL","BELL",mls$city_code)
mls$city_code <- gsub("BF","BELLFLOWER",mls$city_code)
mls$city_code <- gsub("BG","BELL GARDENS",mls$city_code)
mls$city_code <- gsub("CARS","CARSON",mls$city_code)
mls$city_code[mls$city_code == "CMP"] <- gsub("CMP","COMPTON",mls$city_code[mls$city_code == "CMP"])
mls$city_code <- gsub("COI","CITY OF INDUSTRY",mls$city_code)
mls$city_code <- gsub("COM","COMMERCE",mls$city_code)
mls$city_code <- gsub("CUD","CUDAHY",mls$city_code)
mls$city_code <- gsub("DOW","DOWNEY",mls$city_code)
mls$city_code <- gsub("ELM","EL MONTE",mls$city_code)
mls$city_code <- gsub("GD","GLENDALE",mls$city_code)
mls$city_code <- gsub("HAWT","HAWTHORNE",mls$city_code)
mls$city_code[mls$city_code == "HDPK"] <- gsub("HDPK","HIGHLAND PARK",mls$city_code[mls$city_code == "HDPK"])
mls$city_code <- gsub("HG","HAWAIIAN GARDENS",mls$city_code)
mls$city_code <- gsub("HMB","HERMOSA BEACH ",mls$city_code)
mls$city_code[mls$city_code == "HNPK"] <- gsub("HNPK","HUNTINGTON PARK",mls$city_code[mls$city_code == "HNPK"])
mls$city_code[mls$city_code == "ING"] <- gsub("ING","INGLEWOOD",mls$city_code[mls$city_code == "ING"])
mls$city_code <- gsub("LAM","LA MIRADA",mls$city_code)
mls$city_code <- gsub("LNWD","LYNWOOD",mls$city_code)
mls$city_code <- gsub("LW","LAKEWOOD",mls$city_code)
mls$city_code <- gsub("MP","MONTEREY PARK",mls$city_code)
mls$city_code <- gsub("MTB","MONTEBELLO",mls$city_code)
mls$city_code <- gsub("MW","MAYWOOD",mls$city_code)
mls$city_code <- gsub("NWK","NORWALK",mls$city_code)
mls$city_code <- gsub("OA","unknown",mls$city_code)
mls$city_code <- gsub("PAR","PARAMOUNT",mls$city_code)
mls$city_code <- gsub("POM","POMONA ",mls$city_code)
mls$city_code <- gsub("PR","PICO RIVERA",mls$city_code)
mls$city_code <- gsub("REDO","REDONDO BEACH",mls$city_code)
mls$city_code[mls$city_code == "SF"]  <- gsub("SF","SAN FERNANDO",mls$city_code[mls$city_code == "SF"])
mls$city_code[mls$city_code == "SFS"] <- gsub("SFS","SANTA FE SPRINGS",mls$city_code[mls$city_code == "SFS"])
mls$city_code <- gsub("SIGH","SIGNAL HILL",mls$city_code)
mls$city_code <- gsub("SM","SAN MARINO",mls$city_code)
mls$city_code <- gsub("SOG","SOUTH GATE",mls$city_code)
mls$city_code <- gsub("SP","san pedro",mls$city_code)
mls$city_code <- gsub("TORR","torrance",mls$city_code)
mls$city_code <- gsub("WCOV","west covina",mls$city_code)
mls$city_code <- gsub("WH","WHITTIER",mls$city_code)
mls$city_code <- gsub("WILM","WILMINGTON",mls$city_code)

mls$city <- tolower(mls$city_code)
#mls$city_code <- NULL

zip$city <- tolower(zip$city)
zip <- zip[!duplicated(zip$city),]

mls.zip <- sqldf("select a.*, b.zip from 'mls' a left join zip b on a.city = b.city")
table(mls.zip$zip, useNA = "always")

mls.zip$price_per_sqft <- mls.zip$sold_price/mls.zip$Sqft

mls.zip$zip[mls.zip$zip == "unknown"] <- "91304" # manual lookup
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "huntington paramountk"] <- "90255"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "commercepton"]          <- "90221"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "cudahy"]                <- "90201"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "los angelesm"]          <- "90638"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "santa fe san pedrorings"] <- "90670"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "signal hill"] <- "90755"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "highland paramountk"] <- "90043"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "pomona "] <- "91766"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city_code == "COMMERCE"]<- "90040"
mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city_code == "BERMUDA DUNES"]<- "91706"

# Final residential data set
zsdf <- as.data.frame(zs)
res  <- zsdf[c("sold_price", "sold_date", "sqft", "zip","price_per_sqft")]

res$sold_date <- as.Date(strptime(as.character(res$sold_date),"%d/%m/%y %H:%S",tz="UTC"))
res$sqft      <- gsub("--", NA, res$sqft)

res$price_per_sqft      <- gsub("#VALUE!", NA, res$price_per_sqft)
res$price_per_sqft      <- gsub("#DIV/0!", NA, res$price_per_sqft)

res$sold_price      <- as.numeric(res$sold_price)
res$sold_date       <- as.Date(res$sold_date)
res$sqft            <- as.numeric(res$sqft)
res$zip             <- as.factor(res$zip)
res$price_per_sqft  <- as.numeric(res$price_per_sqft)

res$price_per_sqft[res$price_per_sqft < 21 | res$price_per_sqft > 3000] <- NA 

res$sqft[is.na(res$sqft) | res$sqft == 1] <- mean(res$sqft, na.rm = T)
res$sold_date[is.na(res$sold_date)]       <- mean(res$sold_date, na.rm = T)

res$price_per_sqft[is.na(res$price_per_sqft)] <- res$sold_price[is.na(res$price_per_sqft)]/res$sqft[is.na(res$price_per_sqft)]

# Final commericial data set
com <- mls.zip[c("sold_price", "sold_date","Sqft", "zip", "price_per_sqft")]

colnames(com) <- colnames(res)

com$sold_date <- as.Date(strptime(as.character(com$sold_date),"%m/%d/%Y"))

com$sold_price      <- as.numeric(com$sold_price)
com$sold_date       <- as.Date(com$sold_date)
com$sqft            <- as.numeric(com$sqft)
com$zip             <- as.factor(com$zip)
com$price_per_sqft  <- as.numeric(com$price_per_sqft)

com$price_per_sqft[com$price_per_sqft > 20000] <- NA 

com$sqft[is.na(com$sqft) | com$sqft < 200] <- mean(com$sqft, na.rm = T)
#com$sold_date[is.na(com$sold_date)]       <- mean(com$sold_date, na.rm = T)

com <- com[!is.na(com$zip),]

com$price_per_sqft[is.na(com$price_per_sqft)] <- com$sold_price[is.na(com$price_per_sqft)]/com$sqft[is.na(com$price_per_sqft)]

summary(com)

# Save final data sets
saveRDS(com, "com.RDS")
saveRDS(res, "res.RDS")
write.csv(res, "res.csv", row.names = F)
write.csv(com, "com.csv", row.names = F)

# combine final data sets
res$commercial <- 0
com$commercial <- 1
res_com <- rbind(res,com)

saveRDS(res_com, "res_com.RDS")
write.csv(res_com, "res_com.csv", row.names = F)

# Analysis ----------------------------------------------------------------
plot(density(com$price_per_sqft))
lines(density(res$price_per_sqft), col="red")

ppsf.mod  <- glm(price_per_sqft ~ ., data = res_com)
price.mod <- glm(sold_price ~ ., data = res_com)
summary(ppsf.mod)
summary(price.mod) # shows comm vs residential is highly insignificant controlling for other factors


