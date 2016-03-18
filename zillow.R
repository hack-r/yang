
# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, rvest, stringi, sqldf, XML)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Extract -----------------------------------------------------------------
zillow.raw <- fread("zillow.csv")

# Transform ---------------------------------------------------------------
# Get rid of bad column
zillow.raw[,1] <- NULL

# Re-label
xnames <- c("id", "source",   "source1",     "result_num", "url", "address", 
            "listing_type",   "price_int",   "price_formatted",
            "price_currency", "price_title", "price_text", "br_ba_sqft", "built")
setnames(zillow.raw, xnames)
zillow.clean <- zillow.raw

# Separate BR, BA, SQFT
zillow.br_ba_sqft <- zillow.clean[, tstrsplit(br_ba_sqft, "\\â€¢+")]

# Fix mis-aligned values
for(i in 1:nrow(zillow.br_ba_sqft)){
  if(grepl("sqft",zillow.br_ba_sqft$V2[i])) {
    zillow.br_ba_sqft$V3[i] <- zillow.br_ba_sqft$V2[i]
    zillow.br_ba_sqft$V2[i] <- NA
    }
}
