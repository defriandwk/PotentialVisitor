# prepare environment -----------------------------------------------------

# import libs

options(width=50)
options(shiny.maxRequestSize = 30*1024^2)
knitr::opts_chunk$set(cache=TRUE,tidy=TRUE)
options(scipen = 9999)
rm(list=ls())

library(shinydashboard)
library(dashboardthemes)
library(ggthemes)
library(shiny)
library(dplyr)
library(caret)
library(rsample)
library(ggplot2)
library(naniar)
library(isotree)
library(ROCR)
library(plotly)
library(glue)
library(lattice)
library(stringr)

# import dataset
train <- read.csv("ecommerce-train.csv")
model <- readRDS("isotreeModel.RDS")
sample <- read.csv("sample.csv")

train <- train %>% 
  replace_with_na(replace = list(medium = c("(none)","(not set)"))) %>% 
  na.omit() %>% 
  mutate(will_buy_on_return_visit = as.factor(will_buy_on_return_visit)) %>% 
  select(-c(source, pageviews)) %>% 
  droplevels()

linebreaks <- function(n){HTML(strrep(br(), n))}
