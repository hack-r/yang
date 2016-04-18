
# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop//yang")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, RDSTK, rvest, stringi, sqldf, XML, zipcode, zoo)

# Data --------------------------------------------------------------------
zs  <- readRDS("zs.RDS")
mls <- fread("yang_crmls.csv") 

data("zipcode")
zip     <- zipcode[zipcode$state == "CA",]

mls$City <- gsub("LONG","Long Beach",mls$City)
mls$City <- gsub("LA","Los Angeles",mls$City)
mls$City <- gsub("ALH","ALHAMBRA",mls$City)
mls$City <- gsub("ART","ARTESIA",mls$City)
mls$City <- gsub("BBK","BURBANK",mls$City)
mls$City <- gsub("BDPK","BERMUDA DUNES",mls$City)
mls$City <- gsub("BELL","BELL",mls$City)
mls$City <- gsub("BF","BELLFLOWER",mls$City)
mls$City <- gsub("BG","BELL GARDENS",mls$City)
mls$City <- gsub("CARS","CARSON",mls$City)
mls$City <- gsub("CMP","COMPTON",mls$City)
mls$City <- gsub("COI","CITY OF INDUSTRY",mls$City)
mls$City <- gsub("COM","COMMERCE",mls$City)
mls$City <- gsub("CUD","CUDAHY",mls$City)
mls$City <- gsub("DOW","DOWNEY",mls$City)
mls$City <- gsub("ELM","EL MONTE",mls$City)
mls$City <- gsub("GD","GLENDALE",mls$City)
mls$City <- gsub("HAWT","HAWTHORNE",mls$City)
mls$City <- gsub("HDPK","HIGHLAND PARK",mls$City)
mls$City <- gsub("HG","HAWAIIAN GARDENS",mls$City)
mls$City <- gsub("HMB","HERMOSA BEACH ",mls$City)
mls$City <- gsub("HNPK","HUNTINGTON PARK",mls$City)
mls$City <- gsub("ING","INGLEWOOD",mls$City)
mls$City <- gsub("LAM","LA MIRADA",mls$City)
mls$City <- gsub("LNWD","LYNWOOD",mls$City)
mls$City <- gsub("LW","LAKEWOOD",mls$City)
mls$City <- gsub("MP","MONTEREY PARK",mls$City)
mls$City <- gsub("MTB","MONTEBELLO",mls$City)
mls$City <- gsub("MW","MAYWOOD",mls$City)
mls$City <- gsub("NWK","NORWALK",mls$City)
mls$City <- gsub("OA","unknown",mls$City)
mls$City <- gsub("PAR","PARAMOUNT",mls$City)
mls$City <- gsub("POM","POMONA ",mls$City)
mls$City <- gsub("PR","PICO RIVERA",mls$City)
mls$City <- gsub("REDO","REDONDO BEACH",mls$City)
mls$City <- gsub("SF","SAN FERNANDO",mls$City)
mls$City <- gsub("SFS","SANTA FE SPRINGS",mls$City)
mls$City <- gsub("SIGH","SIGNAL HILL",mls$City)
mls$City <- gsub("SM","SAN MARINO",mls$City)
mls$City <- gsub("SOG","SOUTH GATE",mls$City)
mls$City <- gsub("SP","san pedro",mls$City)
mls$City <- gsub("TORR","torrance",mls$City)
mls$City <- gsub("WCOV","west covina",mls$City)
mls$City <- gsub("WH","WHITTIER",mls$City)
mls$City <- gsub("WILM","WILMINGTON",mls$City)

mls$city <- tolower(mls$City)
mls$City <- NULL

zip$city <- tolower(zip$city)
mls.zip <- sqldf("select a.*, b.zip from 'mls' a left join zip b on a.city = b.city")
table(mls.zip$zip, useNA = "always")

mls.zip$price_per_sqft <- mls.zip$sold_price/mls.zip$Sqft

zsdf <- as.data.frame(zs)
res  <- zsdf[c("sold_price", "sold_date", "sqft", "zip","price_per_sqft")]

com <- mls.zip[c("sold_price", "sold_date","Sqft", "zip", "price_per_sqft")]

colnames(com) <- colnames(res)

# Data Types
res$sold_date <- as.Date(strptime(as.character(res$sold_date),"%d/%m/%y %H:%S",tz="UTC"))

res$sold_price <- as.numeric(res$sold_price)
res$sold_date  <- as.Date(res$sold_date)



# Analysis ----------------------------------------------------------------
cor.test(zs$price_per_sqft)

