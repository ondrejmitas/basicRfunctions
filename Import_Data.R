##### import data #####

library(haven)
library(expss)
library(readxl)

## csv

nat_scr <- read_csv("Library/CloudStorage/OneDrive-BUas/work/my_research/experience/ExperiencingNature/2.ProcessedData/ExperienceNature.csv")

## sometimes csv exported from MATLAB

data_for <- read_delim("Library/CloudStorage/OneDrive-BUas/work/my_research/experience/Speeddate/0.RawData/data_for_multilevel_wsdesign_27-05-2024.csv", 
                       delim = "\t", escape_double = FALSE, 
                       trim_ws = TRUE)

## from SPSS

dataN <- read_sav("Library/CloudStorage/OneDrive-BUas/work/my_research/experience/postdoc/3.Output/Niemeyer/0.RawData/Maximizer_March 29, 2018_10.20.sav")

# from Excel

LSV <- read_excel("Library/CloudStorage/OneDrive-BUas/work/my_research/experience/ExperiencingNature/0.RawData/LSV.xlsx")
View(LSV)