import pickle

import uvicorn
from fastapi import FastAPI, File, UploadFile
import numpy as np
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI()

class soil_test_values(BaseModel):
    temp: float
    humidity: float
    ph: float
    label:int


class prod_values(BaseModel):
    season: int
    dist: int
    area: float



class fertil_values(BaseModel):
    season: int
    dist: int
    area: float
    prod: float
    yld:float


origins = [
    "http://localhost",
    "http://localhost:3000",
    "http://127.0.0.1:4350",
    "http://192.168.0.101"

]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


#Load model for paddy fertilization
pickle_file_mod2 = open("C:/Users/User/Documents/Paddies Yield/pkl/RF_fertilization.pkl", "rb")
rf_fertil = pickle.load(pickle_file_mod2)

pickle_file_scale2 = open("C:/Users/User/Documents/Paddies Yield/pkl/scalerRF_fertil.pkl", "rb")
scaler_fertil = pickle.load(pickle_file_scale2)


#Load model for paddy production
pickle_file_mod3 = open("C:/Users/User/Documents/Paddies Yield/pkl/RF_production.pkl", "rb")
rf_prod = pickle.load(pickle_file_mod3)

pickle_file_scale3 = open("C:/Users/User/Documents/Paddies Yield/pkl/scalerRF_prod.pkl", "rb")
scaler_prod = pickle.load(pickle_file_scale3)


#Load model for soil test
pickle_file_mod4 = open("C:/Users/User/Documents/Paddies Yield/pkl/RF_soil_test.pkl", "rb")
soil_test_model = pickle.load(pickle_file_mod4)

pickle_file_scale4 = open("C:/Users/User/Documents/Paddies Yield/pkl/scalerRF_soil_test.pkl", "rb")
scaler_soil_test = pickle.load(pickle_file_scale4)

@app.post("/product_predict")
async def product_predict(take:prod_values):

    feat2=np.array([[take.season,take.dist,take.area]])
    scaled_feat2=scaler_prod.transform(feat2)
    pred2=rf_prod.predict(scaled_feat2)[0]
    return pred2[0],pred2[1] # pred2[0]=Production, Pred2[1]=Yield

@app.post("/fertil_predict")
async def fertil_predict(take:fertil_values):
    feat3=np.array([[take.season,take.dist,take.area,take.prod,take.yld]])
    scaled_feat3=scaler_fertil.transform(feat3)
    pred3=rf_fertil.predict(scaled_feat3)[0]
    return pred3[0],pred3[1] # pred3[0]=Fertilizer, Pred3[1]=Pesticide

@app.post("/soil_test")
async  def soil_test(take:soil_test_values):
    feat4=np.array([[take.temp,take.humidity,take.ph,take.label]])
    scaled_feat4=scaler_soil_test.transform(feat4)
    pred4=soil_test_model.predict(scaled_feat4)[0]
    return pred4[0],pred4[1],pred4[2]



if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)
