library('ggplot2')
library('ggmap')
library('usmap')
library('dplyr')

# Data setup


# Use your own key (below is fake)
# register_google(key = 'aIzaSyCFd4FGbI7axkMV4iS63rl-SvJGfT4m3F4')

locations <- 
  mutate_geocode(fullAddresses, location = address, output = "more") %>%
  select(lon, lat, address...1) %>%
  rename(address = address...1)

locations[is.na(locations$lon), ]

locations[41,] = c(unname(unlist(geocode(location = "2495 Iron Point Rd. Folsom, California"))), 
                   "2495 Iron Point Rd. Folsom, California")
locations[401,] = c(unname(unlist(geocode(location = "432 Private Dr. South Point, Ohio"))), 
                    "432 Private Dr. South Point, Ohio")

