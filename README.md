# Stroke Prediction in R
## Data Mining Project - CIS 3920, Baruch College

### Project Overview
This project aims to predict strokes using various data mining techniques in R as part of the CIS 3920 Data Mining class at Baruch College. We utilize a dataset containing medical and demographic information to build a predictive model.

### Dataset Description
- **Source:** [https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset)
- **Features:**
- 1) id: unique identifier
  2) gender: "Male", "Female" or "Other"
  3) age: age of the patient
  4) hypertension: 0 if the patient doesn't have hypertension, 1 if the patient has hypertension
  5) heart_disease: 0 if the patient doesn't have any heart diseases, 1 if the patient has a heart disease
  6) ever_married: "No" or "Yes"
  7) work_type: "children", "Govt_jov", "Never_worked", "Private" or "Self-employed"
  8) Residence_type: "Rural" or "Urban"
  9) avg_glucose_level: average glucose level in blood
  10) bmi: body mass index
  11) smoking_status: "formerly smoked", "never smoked", "smokes" or "Unknown"*
  12) stroke: 1 if the patient had a stroke or 0 if not
- **Target Variable:**
- Label was the stroke feature

### Objectives
- Understanding the risk factors associated with strokes.
- Building a predictive model in R to accurately predict stroke occurrences.
- Evaluating the model's performance using appropriate metrics.

### Tools and Technologies
- **Language:** R
- **Libraries:** [List R libraries used, e.g., `dplyr`, `ggplot2`, `caret`]
- **Environment:** [Development environment, e.g., RStudio, Jupyter Notebook]

### Installation and Setup
Instructions for installing R and any necessary libraries, along with environment setup instructions.

```R
# Sample installation code
install.packages("dplyr")
