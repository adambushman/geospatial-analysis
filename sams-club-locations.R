library('ggplot2')
library('ggmap')
library('usmap')
library('dplyr')
library('stringr')

###
# Data setup
###
locations = read.csv('sams-club-addresses.csv')


###
# Additional Data Cleaning
###
locations %>% filter(str_detect(address, "#")) # Addresses with a pound sign will not geocode correctly

locs = locations[which(str_detect(locations$address, "#")), ]$address
locations[which(str_detect(locations$address, "#")), ]$address = str_sub(locs, 1, str_locate(locs, "#")[,1]-2)

###
# Use your own key (below is fake)
# register_google(key = 'aIzaSyCFd4FGbI7axkMV4iS63rl-SvJGfT4m3F4')
###
location.ll <- 
  locations %>%
  mutate(full = paste(address, city, state)) %>%
  mutate_geocode(., location = full, output = "more") %>%
  select(lon, lat, address...1) %>%
  rename(address = address...1)

###
# Check for missing data
###
sapply(location.ll, function(x) sum(is.na(x)))


###
# Transform for geometry
###
location.T <- 
  location.ll %>%
  usmap_transform(.)

###
# US Map Plot
###
plot_usmap(regions = c("states"), 
           fill = "#5D9732") +
  geom_point(data = location.T, 
             aes(x = lon.1, y = lat.1), 
             size = 3, 
             color = "#004B8D", 
             alpha = 0.5) + 
  labs(title = "Sam\'s Club Locations Across the United States", 
       caption = "Source: Malls and Retail Wiki\nVisual by @adam_bushman") +
  theme(
    plot.margin = margin(1, 0.5, 1, 0.5, "cm"), 
    plot.title = element_text(size = 15, face = "bold", color = "#004B8D"), 
    plot.caption = element_text(size = 9, face = "italic")
  )

###
# Saving the Plot
###
ggsave('sams-club-locations.jpeg', 
       units = "px", dpi = 150) 
