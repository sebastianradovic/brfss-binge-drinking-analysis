# =========================================
# BRFSS 2023 Analysis
#
# Author: Sebastian Radovic
#
# Research Question: Which demographic factors are most strongly associated 
# with binge drinking among U.S. adults?
# =========================================

# 1. Load packages and dataset
library(haven)
library(dplyr)
library(ggplot2)

brfss <- read_xpt("LLCP2023.XPT")

names(brfss)
dim(brfss)
head(brfss)
glimpse(brfss)

# 2. Select the variables needed for analysis
alcohol_data <- brfss %>%
  select(
    `_RFBING6`,
    `_AGE80`,
    SEXVAR,
    EDUCA,
    INCOME3
  )

names(alcohol_data)
dim(alcohol_data)
head(alcohol_data)

# 3. Explore the variables
table(alcohol_data$`_RFBING6`)
summary(alcohol_data$`_AGE80`)
table(alcohol_data$SEXVAR)
table(alcohol_data$EDUCA)
table(alcohol_data$INCOME3, useNA = "ifany")

# 4. Remove missing or invalid values
alcohol_data <- alcohol_data %>% 
  filter(
    !is.na(`_RFBING6`),
    `_RFBING6` != 9,
    !is.na(`_AGE80`),
    !is.na(SEXVAR),
    !is.na(INCOME3),
    INCOME3 != 77,
    INCOME3 != 99,
    !is.na(EDUCA),
    EDUCA != 9
  )

# 5a. Recode binge drinking
alcohol_data <- alcohol_data %>% 
  mutate(
    Binge_Drinking = factor(
      `_RFBING6`,
      levels = c(1, 2),
      labels = c("No Binge Drinking", "Binge Drinking")
    )
  )

# 5b. Recode sex
alcohol_data <- alcohol_data %>% 
  mutate(
    Sex = factor(
      SEXVAR,
      levels = c(1, 2),
      labels = c("Male", "Female")
    )
  )

# 5c. Recode education
alcohol_data <- alcohol_data %>% 
  mutate(
    Education = factor(
      EDUCA,
      levels = c(1, 2, 3, 4, 5, 6),
      labels = c(
        "Never Attended School",
        "Grades 1–8",
        "Grades 9–11",
        "High School Graduate/GED",
        "Some College/Technical School",
        "College Graduate"
      )
    )
  )

# 5d. Recode income
alcohol_data <- alcohol_data %>% 
  mutate(
    Income = factor(
      INCOME3,
      levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
      labels = c(
        "< $10,000",
        "$10,000–14,999",
        "$15,000–19,999",
        "$20,000–24,999",
        "$25,000–34,999",
        "$35,000–49,999",
        "$50,000–74,999",
        "$75,000–99,999",
        "$100,000–149,999",
        "$150,000–199,999",
        "$200,000+"
      )
    )
  )

# 5e. Create age groups
alcohol_data <- alcohol_data %>% 
  mutate(
    Age_Group = case_when(
      `_AGE80` <= 29 ~ "18–29",
      `_AGE80` <= 44 ~ "30–44",
      `_AGE80` <= 59 ~ "45–59",
      `_AGE80` <= 74 ~ "60–74",
      `_AGE80` >= 75 ~ "75+"
    )
  )

# 5f. Order age groups
alcohol_data <- alcohol_data %>% 
  mutate(
    Age_Group = factor(
      Age_Group,
      levels = c("18–29", "30–44", "45–59", "60–74", "75+")
    )
  )

# 6. Explore the cleaned data
table(alcohol_data$Binge_Drinking)
prop.table(table(alcohol_data$Binge_Drinking))
table(alcohol_data$Age_Group)
table(alcohol_data$Sex)
table(alcohol_data$Education)
table(alcohol_data$Income)

# 7. Overall binge drinking summary
overall_binge_summary <- alcohol_data %>%
  count(Binge_Drinking) %>%
  mutate(
    Percent = round(n / sum(n) * 100, 2)
  )

overall_binge_summary 

# 8. Age group analysis
table(alcohol_data$Age_Group, alcohol_data$Binge_Drinking)

prop.table(
  table(alcohol_data$Age_Group, alcohol_data$Binge_Drinking),
  margin = 1)

age_binge_summary <- alcohol_data %>% 
  group_by(Age_Group) %>% 
  summarise(n = n(),
            Percent_Binge = round(mean(Binge_Drinking == "Binge Drinking") * 100, 2))

age_binge_summary

# 9. Age group bar chart
ggplot(age_binge_summary, aes(x = Age_Group,
                              y = Percent_Binge,
                              fill = Age_Group)) +
  geom_col() +
  geom_text(aes(label = paste0(Percent_Binge, "%")),
    vjust = -0.5) +
  labs(
    title = "Percentage of Adults Reporting Binge Drinking by Age Group",
    x = "Age Group",
    y = "Respondents Reporting Binge Drinking (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "none")

ggsave(filename = "Figures/age_binge_drinking.png",
  width = 8,
  height = 6,
  dpi = 300)

# 10. Sex analysis
table(alcohol_data$Sex, alcohol_data$Binge_Drinking)

prop.table(
  table(alcohol_data$Sex, alcohol_data$Binge_Drinking),
  margin = 1)

sex_binge_summary <- alcohol_data %>% 
  group_by(Sex) %>% 
  summarise(n = n(),
            Percent_Binge = round(mean(Binge_Drinking == "Binge Drinking") * 100, 2))

sex_binge_summary

# 11. Sex bar chart
ggplot(sex_binge_summary, aes(x = Sex,
                              y = Percent_Binge,
                              fill = Sex)) +
  geom_col() +
  geom_text(aes(label = paste0(Percent_Binge, "%")),
            vjust = -0.5) +
  labs(
    title = "Percentage of Adults Reporting Binge Drinking by Sex",
    x = "Sex",
    y = "Respondents Reporting Binge Drinking (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "none")

ggsave(filename = "Figures/sex_binge_drinking.png",
       width = 8,
       height = 6,
       dpi = 300)

# 12. Education analysis
table(alcohol_data$Education, alcohol_data$Binge_Drinking)

prop.table(
  table(alcohol_data$Education, alcohol_data$Binge_Drinking),
  margin = 1)

education_binge_summary <- alcohol_data %>% 
  group_by(Education) %>% 
  summarise(n = n(),
            Percent_Binge = round(mean(Binge_Drinking == "Binge Drinking") * 100, 2))

education_binge_summary

# 13. Education bar chart 
ggplot(education_binge_summary, aes(x = Education,
                              y = Percent_Binge,
                              fill = Education)) +
  geom_col() +
  geom_text(aes(label = paste0(Percent_Binge, "%")),
            vjust = -0.5) +
  labs(
    title = "Percentage of Adults Reporting Binge Drinking by Education Level",
    x = "Education Level",
    y = "Respondents Reporting Binge Drinking (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "none")

ggsave(filename = "Figures/education_binge_drinking.png",
       width = 8,
       height = 6,
       dpi = 300)

# 14. Income analysis
table(alcohol_data$Income, alcohol_data$Binge_Drinking)

prop.table(
  table(alcohol_data$Income, alcohol_data$Binge_Drinking),
  margin = 1)

income_binge_summary <- alcohol_data %>% 
  group_by(Income) %>% 
  summarise(n = n(),
            Percent_Binge = round(mean(Binge_Drinking == "Binge Drinking") * 100, 2))

income_binge_summary

# 15. Income bar chart
ggplot(income_binge_summary, aes(x = Income,
                                    y = Percent_Binge,
                                    fill = Income)) +
  geom_col() +
  geom_text(aes(label = paste0(Percent_Binge, "%")),
            vjust = -0.5) +
  labs(
    title = "Percentage of Adults Reporting Binge Drinking by Income Level",
    x = "Income Level",
    y = "Respondents Reporting Binge Drinking (%)") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "none",
    axis.text.x = element_text(
      angle = 45,
      hjust = 1))

ggsave(filename = "Figures/income_binge_drinking.png",
       width = 8,
       height = 6,
       dpi = 300)

#16. Perform chi-squared tests
chi_squared_age <- chisq.test(table(alcohol_data$Age_Group,
                 alcohol_data$Binge_Drinking))

chi_squared_sex <- chisq.test(table(alcohol_data$Sex,
                                    alcohol_data$Binge_Drinking))

chi_squared_education <- chisq.test(table(alcohol_data$Education,
                                          alcohol_data$Binge_Drinking))

chi_squared_income <- chisq.test(table(alcohol_data$Income,
                                       alcohol_data$Binge_Drinking))

chi_squared_age
chi_squared_sex
chi_squared_education
chi_squared_income


