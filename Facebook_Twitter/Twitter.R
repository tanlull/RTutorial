#install.packages("twitteR")
#install.packages("httpuv")
#install.packages("base64enc")
install.packages("devtools")
library(twitteR)
library("openssl")
library("httpuv")
library("base64enc")
library("devtools")

# Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret. 
consumer_key <- "	GgwX7qjUOZIdduzmSk1TyXmPY"
consumer_secret <- "HIVeehu33nrG0BM4SvtWpRpuXhKS67SP2AWMRHYeeke3kF4uXP"
access_token <- "60633182-PK6bFDVTrzvakYlBACOLONBkOGyAKyT3n35vPOfdp"
access_secret <- "JEkYBBVhIGy2MMdjUn2mNwh9ao3OZZRRYgPd5CyqtNfv0"
options(httr_oauth_cache=T)

#devtools::install_github("jrowen/twitteR", ref = "oauth_httr_1_0")

setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)
tw = twitteR::searchTwitter('#DonaldTrump',n = 100, since = '2017-01-01', retryOnRateLimit = 1000)
d = twitteR::twListToDF(tw)
head(d)
