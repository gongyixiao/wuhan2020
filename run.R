#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))

args = commandArgs(trailingOnly=TRUE)

fread(args[1]) %>% 
  replace(., is.na(.), "0") %>%
  mutate(City = {if("Admin2" %in% names(.)) Admin2 else "City"}) %>%
  select(`City`,`Province_State`,`Country_Region`,`Last_Update`,`Confirmed`, `Deaths`,`Recovered`) %>%
  mutate(`Province_State` = ifelse(`Province_State`=="", `Country_Region`, `Province_State`)) %>%
  mutate(`City` = ifelse(`City`=="City", `Province_State`, `City`)) %>%
  mutate(`Last_Update` = strsplit(`Last_Update`," |T")[[1]][1]) %>%
  rename(`Date`=`Last_Update`) %>%
  fwrite(file = "data.csv", append = TRUE, quote = FALSE, sep = ",", col.names = FALSE)


