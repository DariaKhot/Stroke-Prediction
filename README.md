# 🧠 Stroke Prediction Project 
![Language](https://img.shields.io/badge/Language-R-blue)  
![Environment](https://img.shields.io/badge/Environment-RStudio-orange)  
![Status](https://img.shields.io/badge/Status-Completed-success)  

---

## 📌 Project Overview  
This project was developed as part of **CIS 3920 – Data Mining** at Baruch College.  
The goal was to **predict stroke occurrences** using demographic and medical data, while exploring different data mining techniques in **R**.  

By analyzing risk factors such as hypertension, heart disease, BMI, and smoking status, the project aimed to:  
- Identify **risk factors associated with strokes**  
- Build a **predictive model** to classify patients at risk  
- Evaluate models using **statistical and machine learning methods**  

---

## 📊 Dataset Description  
- **Source:** [Kaggle – Stroke Prediction Dataset](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset)  
- **Target Variable:** `stroke` (1 = patient had a stroke, 0 = no stroke)  

**Features include:**  
- 🧑 Gender (Male, Female, Other)  
- 🎂 Age of patient  
- 💓 Hypertension, Heart Disease (binary)  
- 💍 Ever Married (Yes/No)  
- 👔 Work Type (Private, Self-employed, Govt_job, etc.)  
- 🏡 Residence Type (Urban/Rural)  
- 🍬 Avg Glucose Level in blood  
- ⚖️ Body Mass Index (BMI)  
- 🚬 Smoking Status (never smoked, formerly smoked, smokes, unknown)  

---

## 🎯 Objectives  
- Understand the **risk factors** associated with strokes  
- Train predictive models in **R** to classify stroke occurrence  
- Compare models and evaluate using appropriate metrics  

---

## 🛠️ Tools and Technologies  
- **Language:** R  
- **Environment:** RStudio  
- **Libraries:**  
  - `ggplot2` → visualization  
  - `broom` → tidy statistical modeling  
  - `lattice` → graphics  
  - `caret` → machine learning workflow  
  - `ROSE` → class imbalance handling  
  - `tree`, `class`, `randomForest` → decision trees & ensemble learning  

---

## ⚙️ Installation & Setup  

1. Install **RStudio** → [Download here](https://posit.co/download/rstudio-desktop/)  
2. Install the required R packages:  

```R
install.packages("ggplot2")
install.packages("broom")
install.packages("lattice")
install.packages("caret")
install.packages("ROSE")
install.packages("tree")
install.packages("class")
install.packages("randomForest")

