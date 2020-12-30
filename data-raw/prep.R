## code to prepare datasets goes here

library(tidyverse)
library(httr)
nyt_key <- Sys.getenv("NYT_KEY")
## November 2020
url <- paste0("https://api.nytimes.com/svc/archive/v1/2020/11.json?api-key=",
              my_key)

r <- GET(url)
json <- content(r, as = "text")
nyt <- jsonlite::fromJSON(json)

nyt_headlines <- nyt$response$docs$headline %>% as_tibble() %>%
  bind_cols(section = nyt$response$docs$section_name) %>%
  select(headline = main, section)

nyt_headlines %>%
  write_rds(here::here("data", "nyt_headlines.rds"))


#---------------------------------------------------------------------#

library(tidyverse)

song_lyrics <- read_csv("billboard_lyrics_1964-2015.csv") %>%
  rename(rank = Rank,
         song = Song,
         artist = Artist,
         year = Year,
         lyrics = Lyrics,
         source = Source) %>%
  select(-source) %>%
  filter(lyrics != "instrumental")

write_rds(song_lyrics, here::here("data", "song_lyrics.rds"))

#---------------------------------------------------------------------#

library(gutenbergr)
library(tidyverse)
shakespeare <- gutenberg_download(c(1118, 1515, 1514,
                                    1129, 1524, 1112), meta_fields = "title")


shakespeare <- shakespeare %>% select(title, text) %>%
  mutate(genre = ifelse(title %in% c("Hamlet, Prince of Denmark",
                                     "The Tragedy of Macbeth",
                                     "The Tragedy of Romeo and Juliet"),
                        "Tragedy", "Comedy")) %>%
  select(title, genre, text)

write_rds(shakespeare, here::here("data", "shakespeare.rds"))

#---------------------------------------------------------------------#
