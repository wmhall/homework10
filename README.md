# Homework 10

This is my homework 10. It is an automated workflow that uses the `rarxiv` and `gender` packages from rOpenSci to find all of the journal articles submitted to [arxiv](http://arxiv.org/) in the last week and tell you the gender breakdown of the authors of the papers (i.e. how many male and female authors). Futhermore, it uses the `rvest` package to scrape the [arxiv](http://arxiv.org/) website for the bibligographic information for each journal article. 

This workflow produces two plots:

	* plot_of_number_of_male_and_female_authors.png
	* plot_of_numeber_of_male_and_female_first_authors.png

And a table: 

	* arxiv_papers_author_gender.csv. 
	
This table tells you how many male and female authors were on each paper.

## Important info

You need to have the following packages installed:

	* aRxiv
	* gender
	* dplyr
	* tidyr
	* stringr
	* readr
	* ggplot2
	* rvest

Most of the packages you will have already install from class. The one package you will probably need to install is `aRxiv`.

You can install the package with the command: `install_github("ropensci/aRxiv")`

You can find out more about the package at this [link](https://ropensci.org/tutorials/arxiv_tutorial.html)

## Running the workflow

Because around 3000 articles are submitted to arxiv each week I limited the number of articles that are returned to 15. If you want to change this you need to change the variable `article_limit` in the file called `1_get_data.R`. Even with only 15 articles the workflow will take a couple of minutes to complete. I tried running the workflow with no limits on the number of articles (i.e. all of the journal articles submitted in the last week) and it took about 1 hour to run!

Suggested workflow:

  * Clone this directory. 
  * Start a fresh RStudio session, make sure this directory is the working directory.
  * Run the Makefile using Rstudio's "Build All" button.
  * Or, in a shell, use the command: `make all`
  * `make clean` can be used to delete all the files generated by `make all`
  * You can delete various intermediates "by hand" and use `make all` to re-run necessary parts of the pipeline.
