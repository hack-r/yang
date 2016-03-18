
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

# Remove leading/trailing whitespace
zillow.br_ba_sqft$V1 <- trim(zillow.br_ba_sqft$V1)
zillow.br_ba_sqft$V2 <- trim(zillow.br_ba_sqft$V2)
zillow.br_ba_sqft$V3 <- trim(zillow.br_ba_sqft$V3)
setnames(zillow.br_ba_sqft, c("br", "ba", "lot_size"))

# Indicate units of lot size
zillow.br_ba_sqft$lot_size_units <- NA
for(i in 1:nrow(zillow.br_ba_sqft)){
  if(grepl("sqft", zillow.br_ba_sqft$lot_size[i])) { zillow.br_ba_sqft$lot_size_units[i] <- "sqft"}
}
cat("Apparently units were not an issue for Zillow, but other sites mix in acres")

# Make lot size a number
zillow.br_ba_sqft$lot_size <- gsub("sqft", "", zillow.br_ba_sqft$lot_size)
zillow.br_ba_sqft$lot_size <- trim(zillow.br_ba_sqft$lot_size)

# Add clean BR, BA, SQFT back to main data table
zillow.clean <- cbind(zillow.clean, zillow.br_ba_sqft)


# Load into SQL -----------------------------------------------------------
# For now write to flat file - in the future write directly to SQL DB
saveRDS(zillow.clean, "zillow.clean.RDS")
write.csv(zillow.clean, "zillow.clean.csv", row.names = F)
