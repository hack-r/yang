# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop//yang")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, rvest, stringr, sqldf, XML)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Extract -----------------------------------------------------------------
remax.raw <- fread("remax_commercial.csv")

# Transform ---------------------------------------------------------------
# Make a copy
remax.clean <- remax.raw

# Clean Square Footage
remax.clean$sq_ft_raw <- remax.clean$sq_ft
remax.clean$sq_ft     <-  gsub("SF Bldg","", remax.clean$sq_ft)
remax.clean$sq_ft     <-  gsub("SF GLA","", remax.clean$sq_ft)
remax.clean$sq_ft     <- gsub(",","",remax.clean$sq_ft)
remax.clean$sq_ft     <- gsub("AC","", remax.clean$sq_ft)
remax.clean$sq_ft     <- trim(remax.clean$sq_ft)
remax.clean$sq_ft     <- as.numeric(remax.clean$sq_ft)
remax.clean$sq_ft[2]  <- remax.clean$sq_ft[2]*43560

# Create cap rate column
remax.clean$cap_rate  <- str_extract_all(remax.clean$STATS_CONTENTS, "[0-9.]+%")
remax.clean$cap_rate[remax.clean$cap_rate =="character(0)"] <- NA
remax.clean$cap_rate <- as.character(remax.clean$cap_rate)

# Delete unneeded columns
remax.clean$STATS_LINK        <- NULL
remax.clean$DESCRIPTION_VALUE <- NULL
remax.clean$SHOWONMAP_LABEL   <- NULL
remax.clean$STATS_IMAGE       <- NULL
remax.clean$BLOCK_IMAGE       <- NULL
remax.clean$`BLOCK_IMAGE/_source`      <- NULL
remax.clean$SNAPSHOT_LABEL             <- NULL
remax.clean$`SHOWONMAP_NUMBER/_source` <- NULL
remax.clean$`STATS_LINK/_text` <- NULL
remax.clean$`TD_IMAGE/_source` <- NULL
remax.clean$`STATS_IMAGE/_source` <- NULL
remax.clean$`STATS_IMAGE/_alt`    <- NULL
remax.clean$`BLOCK_IMAGE/_alt`    <- NULL
remax.clean$SHOWONMAP_NUMBER      <- NULL
remax.clean$TD_IMAGE     <- NULL
remax.clean$DESCRIPTION  <- NULL
remax.clean$sq_ft_raw    <- NULL

# Clean city/state
remax.clean$city_state <- gsub(", CA Snapshot", "",remax.clean$city_state)

# Load into Postgres ------------------------------------------------------
write.csv(remax.clean, file = "remax_clean.csv", row.names = F)
