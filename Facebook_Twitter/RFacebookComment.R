library(Rfacebook)
library(RCurl)
library(tidyverse)

fb_oauth <- fbOAuth(app_id="1029251593907923",
                    app_secret="dc00cf1f938397796f55ee4b228c7188")

fb_page <- getPage(page="cupemag",
                token=fb_oauth,
                since = "2018/01/01",
                until = "2018/03/10",
                n= 10)
fb_post <- getPost(post='958865924218839_1545958108842948', token = fb_oauth, comments = TRUE, likes = FALSE)
fb_post$comments$message[36]
fb_post$comments$message
