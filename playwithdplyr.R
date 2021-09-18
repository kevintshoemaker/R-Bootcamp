summarise(mtcars, avg = mean(mpg))
count(mtcars, cyl)

?count

library(dplyr)


starwars %>%
  rowwise() %>%
  mutate(film_count = length(films))

starwars$mass

filter(mtcars, mpg > 20)


distinct(mtcars, gear)

slice(mtcars, 10:15)


slice_sample(mtcars, n = 5, replace = TRUE)

slice_min(mtcars, mpg, prop = 0.25)
slice_head(mtcars, n = 5)


dplyr::select(mtcars, mpg:cyl)

?Comparison

?xor


starwars %>%
  mutate(type = case_when(
    height > 200 | mass > 200 ~ "large",
    species == "Droid" ~ "robot",
    TRUE ~ "other")
  )


summarise(mtcars, across(everything(), mean))

transmute(mtcars, gpm = 1 / mpg)


rename(cars, distance = dist)

cars

head(iris)

ggplot(iris) +
  geom_point(aes(x=Sepal.Length,y=Petal.Length,col=Species))


















