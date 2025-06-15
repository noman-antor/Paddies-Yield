# 🌾 Paddies Yield

**Paddies Yield** is a machine learning-based prediction system integrated with a RESTful FastAPI backend. The system is designed to assist agricultural planning by analyzing soil quality, seasonal factors, and land area to optimize rice production in various districts of Bangladesh.

---

## 📌 Table of Contents

- [📖 Project Overview](#-project-overview)
- [🚀 Features](#-features)
- [🛠 Tech Stack](#-tech-stack)
- [📊 Data Pipeline](#-data-pipeline)
  - [🧹 Data Preprocessing](#-data-preprocessing)
- [📌 Model Selection](#-model-selection)
  - [🧪 Soil Ingredient Test](#-soil-ingredient-test)
  - [🗺️ Region Based Maximum Production](#region-based-maximum-production)
  - [🌿 Fertilizer/Pesticide Recommendation](#-fertilizerpesticide-recommendation)
- [🔗 API Overview](#-api-overview)
  - [Soil Ingredients Test](#soil-ingredients-test)
  - [Region Based Maximum Production](#region-based-maximum-production)
  - [Fertilizer/Pesticide Recommendation](#-fertilizerpesticide-recommendation)
- [📁 Project Structure](#project-structure)
- [🎥 Demo Video ](#-demo-video)


---

## 📖 Project Overview

**Paddies Yield** aims to support decision-making in agriculture by:
- Predicting the concentration of soil nutrients (Nitrogen, Phosphorus, Potassium - NPK) from input data for a particular crop type
- Estimating the maximum possible paddy yield for a given district in Bangladesh based on season and land area.
- Recommending the amount of fertilizer and pesticide required to achieve the maximum predicted yield.

This project leverages real agricultural and environmental datasets and integrates data science with domain expertise in crop production.

---

## 🚀 Features

- Predicts NPK values for soil samples
- Estimates maximum rice yield for districts based on land area and season
- Suggests optimal fertilizer and pesticide amounts
- Clean, modular machine learning pipeline
- RESTful FastAPI backend with interactive Swagger documentation

---

## 🛠 Tech Stack

- **Language:** Python 3.11.7, Dart
- **Libraries:** Scikit-learn, Pandas, Numpy 
- **API Framework:** FastAPI
- **Frontend Framework:** Flutter  
- **Server:** Uvicorn  
- **Others:** Pydantic, JSON, Swagger UI

---

## 📊 Data Pipeline

### 🧹 Data Preprocessing

- Missing data imputation
- Outlier detection and removal
- Conversion of categorical features (e.g., season, district)

## 📌 Model Selection

Models were evaluated for multiple sub-tasks:

---

### 🧪 Soil Ingredient Test  
**Model Used:** `RandomForestRegressor`  
- Predicts the portion of Nitrogen (N), Phosphorus (P), and Potassium (K) in the soil based on input soil characteristics.
- Train-test split: `80/20`

  ![Soil Ingredient Prediction](assets/soil_ingredient_test.png)

---

### 🗺️ Region Based Maximum Production  
**Model Used:** `RandomForestRegressor`  
- Estimates the maximum potential paddy production for a district in Bangladesh given land area and season.
- Train-test split: `80/20`

  ![Region Yield Prediction](assets/region_maximum_production.png)

---

### 🌿 Fertilizer/Pesticide Recommendation  
**Model Used:** `RandomForestRegressor` 
- Recommends the quantity of fertilizer and pesticide required to reach the predicted maximum yield.
- Train-test split: `80/20`

  ![Fertilizer Recommendation](assets/fertilizer&pesticides.png)

---

## 🔗 API Overview

### Soil Ingredients Test
- endpoint: `POST localhost:8050/soil_test`
- Input Format
```js
{
  "temp": 25.89,
  "humidity": 52,
  "ph": 5.6
  "label": 3       // Chickpea
}
```

- Output Format
```python
[
    18.54,  # Nitrogen
    70.66,  # Phosphorus
    19.1    # Potassium
]
```

### Region Based Maximum Production
- endpoint: `POST localhost:8050/product_predict`
- Input Format
```js
{
  "season": 2,           // Summer   
  "dist": 10,            // Mymensingh
  "area": 4586235.256    // Land in hector
}
```

- Output Format
```python
[
    8084739.33,          # Amount of production (Ton)
    1.9009888293129995   # Production per hector (Ton/hector)
]
```

### Fertilizer/Pesticide Recommendation 
- endpoint: `POST localhost:8050/fertil_predict`
- Input Format
```js
{
  "season": 2,                 // Summer   
  "dist": 10,                  // Mymensingh
  "area": 4586235.256,         // Land in hector
  "prod": 8084739.33,          // Amount of production (Ton)
  "yld": 1.9009888293129995    // Production per hector (Ton/hector)
}
```

- Output Format
```python
[
    624744176.0157341,    #Fertilizer
    1408520.8137632033    #Pesticide
]
```
---

## Project Structure
```plaintest
Paddies_Yield/
│
├── api/
│   ├── main.py
│   ├── requirements.txt
├── dataset/
│   ├── soil_ingredients.csv
│   ├── maximum_production.csv
│   ├── fertilizers_pesticides.csv
├── model_files/
│   ├── data_preprocessing.ipynb
│   ├── model_build_on_maximum_production.ipynb
│   ├── model_build_on_fertilizers_pesticides.ipynb
│   ├── model_build_on_soil_ingredients.ipynb             
├── paddies_yield_app/
├── pkl/
│   ├── RF_fertilization.pkl
│   ├── scalerRF_fertil.pkl
│   ├── RF_prodution.pkl
│   ├── scalerRF_prod.pkl
│   ├── RF_soil_test.pkl
│   ├── scalerRF_soil_test.pkl               
```


## 🎥 Demo Video 
[Click here to watch demo](https://drive.google.com/file/d/1Or7wS_EG-0u5zYQWcEdlrTYJ365a3uq4/view?usp=sharing)

