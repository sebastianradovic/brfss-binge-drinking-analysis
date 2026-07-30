# BRFSS Binge Drinking Analysis

## Overview

This project analyzes binge drinking among U.S. adults using the 2023 Behavioral Risk Factor Surveillance System (BRFSS) dataset from the Centers for Disease Control and Prevention (CDC). The analysis was completed in R and explores how binge drinking prevalence differs across age, sex, education level, and income.

## Research Question

**Which demographic factors are most strongly associated with binge drinking among U.S. adults?**

## Dataset

Source: [Centers for Disease Control and Prevention (CDC) – BRFSS 2023](https://www.cdc.gov/brfss/annual_data/annual_2023.html)

The BRFSS is the largest continuously conducted health survey in the world, collecting health-related data from hundreds of thousands of U.S. adults each year.

**Note:** The BRFSS dataset is not included in this repository because of its size. It can be downloaded directly from the CDC using the link above.

## Variables Included

- Age Group
- Sex
- Education Level
- Income
- Binge Drinking Status

## Methods

- Data cleaning and filtering
- Variable recoding
- Descriptive statistics
- Data visualization using ggplot2
- Chi-square tests of independence

## Key Findings

## Key Findings

- Younger adults had the highest prevalence of binge drinking, with prevalence generally decreasing as age increased.
- Males reported nearly twice the prevalence of binge drinking compared with females.
- Binge drinking prevalence generally increased as education level increased.
- Binge drinking prevalence also generally increased as income level increased.
- Chi-square tests indicated statistically significant associations between binge drinking status and each demographic variable examined (age group, sex, education level, and income).

## Visualizations

### Binge Drinking by Age Group

![Age Group](Figures/age_binge_drinking.png)

### Binge Drinking by Sex

![Sex](Figures/sex_binge_drinking.png)

### Binge Drinking by Education Level

![Education](Figures/education_binge_drinking.png?version=2)

### Binge Drinking by Income

![Income](Figures/income_binge_drinking.png)

## Repository Contents

- `BRFSS_binge_drinking_analysis.R` – Complete analysis script
- `Figures/` – Figures generated during the analysis
- `README.md` – Project documentation

## Packages Used

- tidyverse
- dplyr
- ggplot2
- haven
- janitor

## How to Run

1. Download the 2023 BRFSS dataset from the CDC.
2. Place `LLCP2023.XPT` in the project folder.
3. Open `BRFSS_binge_drinking_analysis.R` in RStudio.
4. Install any required packages if prompted.
5. Run the script from beginning to end.

## Author

Sebastian Radovic

Bachelor of Science in Health Sciences

Master of Public Health (in progress)
