##### create nice APA tables ####


library(sjPlot)

sjPlot::tab_model(lmer(SCRmin1 ~ disclosure + match_info + attr_p1 + (1|ppt)  + (1|prtnr), data = data_for), show.stat = TRUE)
