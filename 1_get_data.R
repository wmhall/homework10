library(aRxiv)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)


# set limit for number of articles to return ------------------------------

article_limit <- 15


# find out the present date and create date variable for arxiv ------------

todays_date <- Sys.Date()
the_date_one_week_ago <- Sys.Date() - 7
todays_date_clean <-  str_replace_all(todays_date, "-", "")
the_date_one_week_ago_clean <- 
	str_replace_all(the_date_one_week_ago, "-", "")

date_for_arxiv_search <- paste0('submittedDate:[',
																the_date_one_week_ago_clean, ' TO ', 
																todays_date_clean, ']')


# get the arxiv data ------------------------------------------------------

data <- 
	arxiv_search(date_for_arxiv_search, limit = article_limit)


# write data --------------------------------------------------------------

write_csv(data,"raw_data.csv")
