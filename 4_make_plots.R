library(aRxiv)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)


# read data ---------------------------------------------------------------

counts_of_male_and_female_authors <-
	read_csv("counts_of_male_and_female_authors.csv")

counts_of_male_and_female_first_authors <- 
	read_csv("counts_of_male_and_female_first_authors.csv")

df_with_gender_and_cite_info <-  
	read_csv("arxiv_papers_author_gender.csv")

# make plots --------------------------------------------------------------

p1 <- ggplot(counts_of_male_and_female_authors,
						 aes(x = factor(gender), 
						 		y=n_obs_gender, fill = factor(gender))) + 
	geom_bar(stat = "identity") + 
	labs(x="author gender", 
			 y= "count", 
			 title = "Number of male and female authors") +
	guides(fill=guide_legend(title=NULL))


p2 <- ggplot(counts_of_male_and_female_first_authors,
						 aes(x = factor(gender), 
						 		y=n_obs_gender_first_author, fill = factor(gender))) + 
	geom_bar(stat = "identity") + 
	labs(x="author gender", 
			 y= "count", 
			 title = "Number of male and female first authors") +
	guides(fill=guide_legend(title=NULL))


# save plots --------------------------------------------------------------

ggsave(p1, filename = 
			 	"plot_of_number_of_male_and_female_authors.png")
ggsave(p2, filename =
			 	"plot_of_numeber_of_male_and_female_first_authors.png")



