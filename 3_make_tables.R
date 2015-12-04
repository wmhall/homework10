library(aRxiv)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)
library(gender)
library(rvest)

df_tall_authors <-  read_csv("df_tall_authors.csv")
data <- read_csv("raw_data.csv")

# get author gender using the gender package ------------------------------

df_author_genders <- 
	df_tall_authors %>% 
	mutate(author = str_to_lower(author)) %>% 
	filter(grepl("^([a-z][^\\.])", author)) %>%
	separate(author, c("f_name", "l_name"), 
					 sep = " ", extra = "merge") %>% 
	group_by(id, key) %>% 
	do(gender(.$f_name)) %>% 
	select(id, gender)


# create counts for tables ------------------------------------------------

#get overall counts
counts_of_male_and_female_authors <- 
	df_author_genders %>%  
	group_by(gender) %>% 
	summarise(n_obs_gender = n())

#get first author counts
counts_of_male_and_female_first_authors <- 
	df_author_genders %>% 
	filter(key == "author1") %>% 
	group_by(gender) %>% 
	summarise(n_obs_gender_first_author = n())

# create dataframe with author genders and citation info ------------------

df_author_genders_wide <- 
	df_author_genders %>% 
	group_by(id, gender) %>% 
	summarise(count = n()) %>% 
	spread(gender, count) %>% 
	rename(female_authors = female, male_authors = male)

df_with_citaion_info <- 
	data %>% 
	group_by(id) %>% 
	mutate(citation_info=sapply(link_abstract, 
															function(url) {read_html(url) %>% 
																	html_nodes(
																		'.extra-ref-cite li:nth-child(1) a:nth-child(1)') %>% 
																	html_text()}),
				 citation_link = sapply(link_abstract, function (url) {
				 	read_html(url) %>%
				 		html_nodes('.extra-ref-cite li:nth-child(1) a:nth-child(1)') %>% 
				 		html_attr("href") 
				 } )) %>% 
	select(id, title, citation_info, citation_link)

df_with_gender_and_cite_info <- 
	left_join(df_author_genders_wide, df_with_citaion_info, by = "id")


# write out data files ----------------------------------------------------

write_csv(counts_of_male_and_female_authors, 
					"counts_of_male_and_female_authors.csv")

write_csv(counts_of_male_and_female_first_authors,
					"counts_of_male_and_female_first_authors.csv")

write_csv(df_with_gender_and_cite_info, 
					"arxiv_papers_author_gender.csv")

