
# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop//yang")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, rvest, stringi, sqldf, XML)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Extract -----------------------------------------------------------------
# From Extractor
zs1 <- read.csv("zillow sold 155 clean.csv")
zs1 <- zs1[!is.na(zs1$`Price.sqft`),]

zs1$sold_price     <- zs1$`Sold.price`
zs1$price_per_sqft <- zs1$`Price.sqft`
zs1$street_address <- zs1$Address
zs1$sold_date      <- zs1$`Sold.date`

zs1$`Sold date`  <- NULL
zs1$Address      <- NULL
zs1$`Price sqft` <- NULL
zs1$`Sold price` <- NULL

zs1$city  <- "see address"
zs1$state <- "CA"
zs1$facts <- "None"

zs1 <- zs1[c("url","beds","baths","sqft","sold_price","sold_date","price_per_sqft","facts","street_address","city","state","zip")]

# From Crawler
zs2 <- fread("zillow_sold_single_page_clean.csv")

zs2$Widget <- NULL

# Merge
zs <- rbind(zs1,zs2)


# Save --------------------------------------------------------------------
write.csv(zs, "zillow_sold_combined_clean.csv", row.names = F)
saveRDS(zs, "zs.RDS")
