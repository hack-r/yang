
# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop//yang")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, RDSTK, RgoogleMaps, rvest, stringi, sqldf, XML, zipcode, zoo)

# Data --------------------------------------------------------------------
zs  <- readRDS("zs.RDS")
mls <- fread("yang_crmls2.csv") 

mls$City[mls$City ==	"ALH"] <- "ALHAMBRA"		
mls$City[mls$City ==	"ART"] <- "ARTESIA"		
mls$City[mls$City ==	"BBK"] <- "BURBANK"		
mls$City[mls$City ==	"BDPK"] <- "BERMUDA DUNES"		
mls$City[mls$City ==	"BELL"] <- "BELL"		
mls$City[mls$City ==	"BF"] <- "BELLFLOWER"		
mls$City[mls$City ==	"BG"] <- "BELL GARDENS"		
mls$City[mls$City ==	"CARS"] <- "CARSON"		
mls$City[mls$City ==	"CMP"] <- "COMPTON"		
mls$City[mls$City ==	"COI"] <- "CITY OF INDUSTRY"		
mls$City[mls$City ==	"COM"] <- "COMMERCE"		
mls$City[mls$City ==	"CUD"] <- "CUDAHY"		
mls$City[mls$City ==	"DOW"] <- "DOWNEY"		
mls$City[mls$City ==	"ELM"] <- "EL MONTE"		
mls$City[mls$City ==	"GD"] <- "GLENDALE"		
mls$City[mls$City ==	"HAWT"] <- "HAWTHORNE"		
mls$City[mls$City ==	"HDPK"] <- "HIGHLAND PARK"	
mls$City[mls$City ==	"HG"] <- "HAWAIIAN GARDENS"		
mls$City[mls$City ==	"HMB"] <- "HERMOSA BEACH "		
mls$City[mls$City ==	"HNPK"] <- "HUNTINGTON PARK"		
mls$City[mls$City ==	"ING"] <- "INGLEWOOD"		
mls$City[mls$City ==	"LA"] <- "Los Angeles"		
mls$City[mls$City ==	"LAM"] <- "LA MIRADA"		
mls$City[mls$City ==	"LNWD"] <- "LYNWOOD"		
mls$City[mls$City ==	"LONG"] <- "Long Beach"		
mls$City[mls$City ==	"LW"] <- "LAKEWOOD"		
mls$City[mls$City ==	"MP"] <- "MONTEREY PARK"		
mls$City[mls$City ==	"MTB"] <- "MONTEBELLO"		
mls$City[mls$City ==	"MW"] <- "MAYWOOD"		
mls$City[mls$City ==	"NWK"] <- "NORWALK"		
mls$City[mls$City ==	"OA"] <- "unknown"		
mls$City[mls$City ==	"PAR"] <- "PARAMOUNT"		
mls$City[mls$City ==	"POM"] <- "POMONA "		
mls$City[mls$City ==	"PR"] <- "PICO RIVERA"		
mls$City[mls$City ==	"REDO"] <- "REDONDO BEACH"		
mls$City[mls$City ==	"SF"] <- "SAN FERNANDO"		
mls$City[mls$City ==	"SFS"] <- "SANTA FE SPRINGS"		
mls$City[mls$City ==	"SIGH"] <- "SIGNAL HILL"		
mls$City[mls$City ==	"SM"] <- "SAN MARINO"		
mls$City[mls$City ==	"SOG"] <- "SOUTH GATE"		
mls$City[mls$City ==	"SP"] <- "san pedro"		
mls$City[mls$City ==	"TORR"] <- "torrance"		
mls$City[mls$City ==	"WCOV"] <- "west covina"		
mls$City[mls$City ==	"WH"] <- "WHITTIER"		
mls$City[mls$City ==	"WILM"] <- "WILMINGTON"		

mls$City[mls$City == "WS"]   <- "WESTCHESTER"
mls$City[mls$City == "WHO"]  <- "unknown"
mls$City[mls$City == "WEH"]  <-  "unknown"
mls$City[mls$City == "WAL"]  <- "WALNUT"
mls$City[mls$City == "VEN"]  <- "VERNON" # maybe?
mls$City[mls$City == "TUJ"]  <- "TUJUNGA"
mls$City[mls$City == "TMPL"] <- "TEMPLE CITY"
mls$City[mls$City == "SVL"]  <- "SKY VALLEY"
mls$City[mls$City == "SUNL"] <- "SUNLAND"
mls$City[mls$City == "SPAS"] <- "SOUTH PASADENA"
mls$City[mls$City == "SMRO"] <- "SAN MARINO"
mls$City[mls$City == "SCL"]  <- "SAN CLEMENTE"
mls$City[mls$City == "SDMS"] <- "SAN DEIGO"
mls$City[mls$City == "PDL"]  <- "PALMDALE"
mls$City[mls$City == "PBLM"] <- "unknown"
mls$City[mls$City == "ROW"]  <- "ROWLAND HEIGHTS"
mls$City[mls$City == "RLT"]  <- "RIALTO"
mls$City[mls$City == "SCL"]  <- "SAN CLEMENTE" #maybe?
mls$City[mls$City == "PAS"]  <- "PASADENA"
mls$City[mls$City == "SGAB"] <- "SAN GABRIEL"
mls$City[mls$City == "UNIC"] <- "unknown"
mls$City[mls$City == "LX"]   <- "LENNOX"
mls$City[mls$City == "GLDR"] <- "GLENDORA"
mls$City[mls$City == "ESER"] <- "unknown" 
mls$City[mls$City == "ES"]   <- "EL SEGUNDO"
mls$City[mls$City == "LNCR"] <- "LANCASTER"
mls$City[mls$City == "LVRN"] <- "LA VERNE"
mls$City[mls$City == "MR"]   <- "MARINA DEL REY"
mls$City[mls$City == "MNRO"] <- "MONROVIA"
mls$City[mls$City == "LOM"]  <- "LOMITA"
mls$City[mls$City == "NHLW"] <- "NORTH HOLLYWOOD"
mls$City[mls$City == "HH"]   <-  "HACIENDA HEIGHTS"
mls$City[mls$City == "DUAR"] <- "DUARTE"
mls$City[mls$City == "CULV"] <- "CULVER CITY"
mls$City[mls$City == "ARCD"] <- "unknown"
mls$City[mls$City == "AZU"]  <- "AZUSA"
  
  
mls$City <- tolower(mls$City)

write.csv(mls, "mls_cities.csv", row.names = F)
# mls.zip$zip[mls.zip$zip == "unknown"] <- "91304" # manual lookup
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "huntington paramountk"] <- "90255"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "commercepton"]          <- "90221"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "cudahy"]                <- "90201"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "los angelesm"]          <- "90638"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "santa fe san pedrorings"] <- "90670"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "signal hill"] <- "90755"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "highland paramountk"] <- "90043"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city == "pomona "] <- "91766"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city_code == "COMMERCE"]<- "90040"
# mls.zip$zip[is.na(mls.zip$zip) & mls.zip$city_code == "BERMUDA DUNES"]<- "91706"

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

# Data Visualization ------------------------------------------------------

