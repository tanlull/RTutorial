#install.packages("Rfacebook")
#install.packages("RCurl")
#install.packages("tidyverse")


library(Rfacebook)
library(RCurl)
library(tidyverse)

fb_oauth <- fbOAuth(app_id="1029251593907923",
                    app_secret="dc00cf1f938397796f55ee4b228c7188")

CupE <- getPage(page="cupemag",
                token=fb_oauth,
                since = "2018/01/01",
                until = "2018/03/10",
                n= 20000)
head(CupE)
View(CupE)
class(CupE)

CupE.org <- CupE

#dplyr
# Select data and alias column
CupE <- CupE %>% 
  select(post = message,
         comments = comments_count,
         likes = likes_count,
         shares = shares_count)

View(CupE)
write_csv(CupE,"CupE_Raw.csv")

head(CupE$post)

length(CupE$post)

str(CupE$post)


#replace \n with space

CupE$post <- gsub("\n","",CupE$post)

head(CupE$post)


#add new column by spliting column post using model keyboard
cupE.extNames <- CupE %>%
    separate(post, into = c ("post","model"),
             sep="(Model|mode)")

View(cupE.extNames)

#split photographer
cupE.extNames2 <- cupE.extNames %>%
    separate(model,into = c("model","photo_by"),
             sep = "(Photo|photo|Photographer|photographer)")
View(cupE.extNames2)

# clean photographer data
cupE.extNames2$photo_by <- gsub("(Thx|Affiliation|http|Place|Location|& Lighting).*",
                                "",cupE.extNames2$photo_by)

cupE.extNames2$photo_by <- gsub("(grapher|graphy|graper|grap|@|gapher|#)",
                                "",cupE.extNames2$photo_by)

cupE.extNames2$photo_by <- gsub("Fan|:","",cupE.extNames2$photo_by)

cupE.extNames2$photo_by <- gsub("gr[as]?p?her","",cupE.extNames2$photo_by)

#Clean model
cupE.extNames2$model <- gsub(":|@","",cupE.extNames2$model)
cupE.extNames2$model <- gsub("(http|Pics|Pic |Video|Thx|Cr.?|#|--|__|Line|-).*","",cupE.extNames2$model)

#save file
getwd()
write_csv(cupE.extNames2,"CupE_Clean1.csv")
dir()



#Visualization
cupE.TopModel <- cupE.extNames2 %>%
  count(model,sort=TRUE) %>%
  filter(n>1,
         !is.na(model)) %>%
  head(20)

View(cupE.TopModel)

#Plot
ggplot(data = cupE.TopModel,
       mapping = aes(x=reorder(model,+n),y=n))+
  geom_col(fill ="salmon")+
  coord_flip()+
  labs(x="Model Name",
       y="count of Comebacks")+
  theme_minimal()


#Photographer

cupE.TopPhoto <- cupE.extNames2 %>%
  count(photo_by,sort=TRUE) %>%
  filter(n>1,
         !is.na(photo_by)) %>%
  head(20)

View(cupE.TopPhoto)

ggplot(data = cupE.TopPhoto,
       mapping = aes(x=reorder(photo_by,+n),y=n))+
  geom_col(fill ="salmon")+
  coord_flip()+
  labs(x="Photo By",
       y="count of Photographers")+
  theme_minimal()



#Who got most Like 

cupE.extNames2 %>%
  group_by(model) %>%
  summarize(likes = sum(likes),
            shares = sum(shares),
            comments = sum(comments)) %>%
  filter(!is.na(model)) %>%
  arrange(desc(likes)) %>%
  head(20) %>%
  ggplot(aes(x=reorder(model,+likes),y=likes))+
  geom_col(fill ="salmon")+
  coord_flip()+
  labs(x="Model Name",
       y="Like")+
  theme_minimal()

#Who got most share
cupE.extNames2 %>%
  group_by(model) %>%
  summarize(likes = sum(likes),
            shares = sum(shares),
            comments = sum(comments)) %>%
  filter(!is.na(model)) %>%
  arrange(desc(shares)) %>%
  head(20) %>%
  ggplot(aes(x=reorder(model,+shares),y=shares))+
  geom_col(fill ="salmon")+
  coord_flip()+
  labs(x="Model Name",
       y="shares")+
  theme_minimal()


#Who got most comment
cupE.extNames2 %>%
  group_by(model) %>%
  summarize(likes = sum(likes),
            shares = sum(shares),
            comments = sum(comments)) %>%
  filter(!is.na(model)) %>%
  arrange(desc(comments)) %>%
  head(20) %>%
  ggplot(aes(x=reorder(model,+comments),y=comments))+
  geom_col(fill ="salmon")+
  coord_flip()+
  labs(x="Model Name",
       y="comments")+
  theme_minimal()

#distribution 

ggplot(data=cupE.extNames2,
       mapping = aes(x=likes))+
  geom_histogram(aes(y= ..density..),
                 bandwidth =1000,fill = "salmon")+
  geom_density(col ="blue",size=1)+
  theme_minimal()+
  labs(x="Likes",
       y="Density")
