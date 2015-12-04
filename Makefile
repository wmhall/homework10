all: plot_of_numeber_of_male_and_female_first_authors.png

clean:
	rm -f *.png *.csv *.pdf

raw_data.csv: 1_get_data.R
	Rscript 1_get_data.R
	
df_tall_authors.csv: raw_data.csv 2_clean_the_data.R
	Rscript 2_clean_the_data.R

counts_of_male_and_female_authors.csv: df_tall_authors.csv raw_data.csv 3_make_tables.R
	Rscript 3_make_tables.R
	
counts_of_male_and_female_first_authors.csv: df_tall_authors.csv raw_data.csv 3_make_tables.R
	Rscript 3_make_tables.R

arxiv_papers_author_gender.csv: df_tall_authors.csv raw_data.csv 3_make_tables.R
	Rscript 3_make_tables.R
	
plot_of_number_of_male_and_female_authors.png: counts_of_male_and_female_authors.csv counts_of_male_and_female_first_authors.csv 4_make_plots.R
	Rscript 4_make_plots.R

plot_of_numeber_of_male_and_female_first_authors.png: counts_of_male_and_female_authors.csv counts_of_male_and_female_first_authors.csv 4_make_plots.R
	Rscript 4_make_plots.R
	rm -rf Rplot.pdf

