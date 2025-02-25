# Speed - mortality curves

#speeds <- seq(0,30,length=1000)
#collides <-  (.9 / (1 + exp(-0.5*(speeds - 11.8))))
#plot(collides~speeds, ylim=c(0,1))
#abline(h=.5, v=11.8)

speeds <- seq(0,30,length=1000)
collides <-  (.9 / (1 + exp(-0.15*(speeds - 11.8))))
plot(collides~speeds, ylim=c(0,1), type='l', lwd=3, col='firebrick')
abline(h=.5*.9, v=11.8)
abline(h=.9*.9, v=26.5)


fitlog <- function(v1, p1, v2, p2, asymptote = 1){
  #v1 = 11.8; p1 = 0.5; v2 = 20; p2 = 0.95
  speeds <- seq(0,30,length=1000)
  c1 <- seq(-10, 0, length=1000)
  c2 <- seq(0.001, 30, length = 1000)
  df <- expand.grid(c1, c2)
  df$p1 <- (asymptote/ (1 + exp(df$Var1*(v1 - df$Var2))))
  df$e1 <- p1 - df$p1
  df$p2 <- (asymptote/ (1 + exp(df$Var1*(v2 - df$Var2))))
  df$e2 <- p2 - df$p2
  df$etot <- abs(df$e1) + abs(df$e2)
  mine <- which.min(df$etot)
  #hist(df$etot)
  df[mine,]

  speeds <- seq(0, 40, length=1000)
  (c1 <- df$Var1[mine])
  (c2 <- df$Var2[mine])
  avoids <- (asymptote/ (1 + exp(c1*(speeds - c2))))
  plot(avoids~speeds, type='l', col='firebrick', ylim=c(0,1), lwd=2)
  abline(h=p1, v=v1, lty=1, col='steelblue3')
  abline(h=p2, v=v2, lty=3, col='steelblue3')

  dfmin <- data.frame(c1, c2, asymptote)
  return(dfmin)
}

#"Other > 40m"         "Passenger > 100m"    "Tug < 50m"           "Towing < 50m"        "Cargo > 100m"
#"Fishing < 60m"       "Other < 40m"         "Pleasurecraft < 40m" "Sailing"             "Tanker > 100m"

# With asymptote of 1

asymptote = .9

(df4 <-
    data.frame(type = 'Cargo > 180m | Passenger > 180m | Tanker > 180m | Other > 100m',
               fitlog(v1 = 11.8, p1 = (asymptote / 2),
                      v2 = 26.5, p2 = (0.95 * asymptote), asymptote = asymptote)))

(df2 <-
    data.frame(type = 'Tug < 50m | Towing < 50m',
               fitlog(v1 = 15.8, p1 = (asymptote / 2),
                      v2 = 29.5, p2 = (0.9 * asymptote), asymptote = asymptote)))

(df3 <-
    data.frame(type = 'Fishing < 60m | Other > 40m',
               fitlog(v1 = 19.8, p1 = (asymptote / 2),
                      v2 = 31.5, p2 = (0.85 * asymptote), asymptote = asymptote)))

(df1 <-
    data.frame(type = 'Pleasurecraft < 40m | Other < 40m | Sailing',
               fitlog(v1 = 23.8, p1 = (asymptote / 2),
                      v2 = 32.5, p2 = (0.8 * asymptote), asymptote = asymptote)))

(dfs <- rbind(df1, df2, df3, df4))

saveRDS(dfs, file='data-raw/p_avoidance.RData')
p_collision <- readRDS('data-raw/p_avoidance.RData')
usethis::use_data(p_collision, overwrite = TRUE)


# Plot

predlog <- function(speeds = seq(0, 30, length=1000),
                    c1, c2, asymptote){
  avoids <- (asymptote/ (1 + exp(c1*(speeds - c2))))
  dfi <- data.frame(speeds, avoids)
  return(dfi)
}

mr <- data.frame()
i=1
for(i in 1:nrow(dfs)){
  (dfi <- dfs[i,])
  preds <- predlog(c1=dfi$c1, c2 = dfi$c2, asymptote = dfi$asymptote)
  preds$type = dfi$type
  mr <- rbind(mr, preds)
}

mr %>% head

saveRDS(mr, file='data-raw/collision_fig.RData')

ggplot(mr, aes(x=speeds, y=avoids, color=type)) +
  geom_line(lwd=1.2, alpha=.75) +
  scale_x_continuous(breaks=seq(0,30,by=5)) +
  scale_y_continuous(breaks=seq(0,1,by=.1), limits=c(0,1)) +
  theme_light() +
  xlab('Vessel speed') +
  ylab('P(Collision)') +
  labs(color = 'Vessel class group')


#########################################################################

