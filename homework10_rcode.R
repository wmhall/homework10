library(aRxiv)
library(dplyr)
library(tidyr)
library(stringr)
library(readr)
library(ggplot2)


# set limit for number of articles to return ------------------------------

article_limit <- 25


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


# clean the author variable -----------------------------------------------


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

p1 <- ggplot(counts_of_male_and_female_authors,
       aes(x = factor(gender), 
           y=n_obs_gender, fill = factor(gender))) + 
  geom_bar(stat = "identity") + 
  labs(x="author gender", 
       y= "count", 
       title = "Number of male and female authors") +
  guides(fill=guide_legend(title=NULL))

#get first author counts
counts_of_male_and_female_first_authors <- 
df_author_genders %>% 
  filter(key == "author1") %>% 
  group_by(gender) %>% 
  summarise(n_obs_gender_first_author = n())
  
p2 <- ggplot(counts_of_male_and_female_first_authors,
       aes(x = factor(gender), 
           y=n_obs_gender_first_author, fill = factor(gender))) + 
  geom_bar(stat = "identity") + 
  labs(x="author gender", 
       y= "count", 
       title = "Number of male and female first authors") +
  guides(fill=guide_legend(title=NULL))


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


# write data and plots to files -------------------------------------------

write_csv(counts_of_male_and_female_authors, 
          "counts_of_male_and_female_authors.csv")

write_csv(counts_of_male_and_female_first_authors,
          "counts_of_male_and_female_first_authors.csv")

write_csv(df_with_gender_and_cite_info, "arxiv_papers_author_gender.csv")

ggsave(p1, filename = 
         "plot_of_number_of_male_and_female_authors.png")
ggsave(p2, filename =
         "plot_of_numeber_of_male_and_female_first_authors.png")



