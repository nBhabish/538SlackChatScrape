# Loading Configurations
library(tidyverse)
library(rvest)

fivethirtyeight_slack_pages <- tibble(page_num = 1:26)

# Creating the pages of articles to scrape
fivethirtyeight_slack_pages <- fivethirtyeight_slack_pages %>%
  mutate(page_link = paste0(
    "https://fivethirtyeight.com/tag/slack-chat/page/",
    page_num,
    "/"
  ))


# Create a function to grab the links
get_links <- function(page) {
  
  page <- read_html(page)
 
  page %>%
    html_nodes("#main .entry-title a") %>%
    html_attr("href") %>%
    as_tibble() %>%
    rename(links = "value")
}

# Scrape the links

fivethirtyeight_slack_pages <- fivethirtyeight_slack_pages %>% 
  mutate(links = map(page_link, get_links)) %>% 
  unnest(links)


# Scraping the slack chats from the links

links <- "https://fivethirtyeight.com/features/how-rush-limbaugh-shaped-the-gop"

# Function to scrape the slack chats from the links
get_slackchats <- function(links) {
  links <- read_html(links)
  links %>%
    html_nodes(".single-post-content > p ") %>%
    html_text() 
}


# Unnesting the slack chats in the tibble
fivethirtyeight_slack_pages <- fivethirtyeight_slack_pages %>% 
  mutate(slack_chats = map(links, get_slackchats)) %>% 
  unnest(slack_chats)
 
# Taking a look at the data

fivethirtyeight_slack_pages %>% 
  view()



