# Options -----------------------------------------------------------------
setwd("C://users//jmiller//Desktop")

# Functions and Libraries -------------------------------------------------
pacman::p_load(data.table, rvest, stringi, sqldf, XML)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Extract -----------------------------------------------------------------
zillow.raw <- fread("zillow.csv")
