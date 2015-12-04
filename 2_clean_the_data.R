library(aRxiv)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)

# clean the author variable -----------------------------------------------

data <- read_csv("raw_data.csv")

data_subset_author_only <- 
	data %>% select(id, authors )

author_variable_names <- paste0("author", 
																1:(1 + max(str_count(data_subset_author_only$authors, 
																										 "\\|"))))
df_tall_authors <- 
	data_subset_author_only %>% 
	separate(authors, into = author_variable_names, 
					 sep = "\\|", extra = "merge") %>% 
	gather(key, author, -id)

write_csv(df_tall_authors, "df_tall_authors.csv")