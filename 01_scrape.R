#!/usr/bin/env Rscript
cat("\014")

options(encoding = "UTF-8")

library(dplyr)
library(glue)
library(purrr)
library(readr)
library(rvest)

source("helper01_timestamp-filename.R")

src = read_html("https://www.craigslist.org/about/sites")
us_nodes = html_nodes(src, css = ":nth-child(4) .box")

states = us_nodes %>%
  html_nodes(css = "h4") %>%
  html_text()

region_nodes = html_nodes(us_nodes, css = "ul")

region = region_nodes %>%
  html_text() %>%
  gsub("(?<=\\n)( )+(?=[A-Za-z]|$)", "", ., perl = TRUE) %>%
  strsplit("\n") %>%
  map(~tibble(region = .x)) %>%
  `names<-`(states) %>%
  bind_rows(.id = "state")

site_url = map_dfr(region_nodes,
                   ~{
                     .x %>%
                       html_nodes(css = "li a") %>%
                       html_attr("href") %>%
                       tibble(site_url = .)
                   })

craigslists =
  bind_cols(region, site_url) %>%
  mutate(site_name = gsub("https://|\\.craigslist\\.org/", "", site_url),
         search_url = glue("{site_url}search/apa")) %>%
  select(state, region, site_name, site_url, search_url)

write_csv(craigslists, path = timestamp_filename("craigslists.csv"))
