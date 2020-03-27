#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyr))

args = commandArgs(trailingOnly=TRUE)

fread(args[1]) %>% 
  replace(., is.na(.), "0") %>%
  mutate(Admin2 = {if("Admin2" %in% names(.)) Admin2 else ""}) %>%
  mutate(`Province/State` = {if("Province_State" %in% names(.)) Province_State else `Province/State`}) %>%
  mutate(`Country/Region` = {if("Country_Region" %in% names(.)) Country_Region else `Country/Region`}) %>%
  mutate(`Last Update` = {if("Last_Update" %in% names(.)) Last_Update else `Last Update`}) %>%
  rename(`Date`=`Last Update`) %>%
  filter(`Country/Region` != "The Bahamas") %>%
  mutate(`Country/Region` = gsub("Bahamas, The","Bahamas", `Country/Region`)) %>%
  filter(`Country/Region` != "The Gambia") %>%
  mutate(`Country/Region` = gsub("Gambia, The","Gambia", `Country/Region`)) %>%
  mutate(`Country/Region` = gsub("Korea, South","South Korea", `Country/Region`)) %>%
  mutate(`Country/Region` = gsub("Republic of Korea","South Korea", `Country/Region`)) %>%
  mutate(`Province/State` = ifelse(grepl(",", `Province/State`), gsub(", ", ",",`Province/State`), paste0("City,",`Province/State`))) %>%
  separate(`Province/State`, into = c("City", "Province/State"), sep=",") %>%
  mutate(`Province/State` = ifelse(`Province/State`=="", `Country/Region`, `Province/State`)) %>%
  mutate(`Province/State` = ifelse(is.na(state.abb[match(`Province/State`, state.name)]),`Province/State`, state.abb[match(`Province/State`, state.name)])) %>%
  mutate(`City` = ifelse(Admin2=="", `Province/State`, Admin2)) %>%
  mutate(City = ifelse((`Country/Region`=="US")&(`City`!=`Province/State`), paste(City, `Province/State`,sep="/"), City)) %>%
  mutate(`Date` = strsplit(`Date`," |T")[[1]][1]) %>%
  mutate(`Date` = ifelse(grepl("/", `Date`),paste(paste0("20",strsplit(`Date`,"/")[[1]][3]),strsplit(`Date`,"/")[[1]][1],strsplit(`Date`,"/")[[1]][2],sep="-"),`Date`)) %>%
  mutate(`Date` = gsub("202020","2020", `Date`)) %>%
  select(`City`,`Province/State`,`Country/Region`,`Date`,`Confirmed`, `Deaths`,`Recovered`) %>%
  fwrite(file = "data.csv", append = TRUE, quote = FALSE, sep = ",", col.names = FALSE)