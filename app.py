from flask import Flask, request, jsonify
import numpy as np
import joblib

app = Flask(__name__)

scaler = joblib.load('age_scaler.pkl')
model = joblib.load('heart_risk_model.pkl')

@app.route('/')
def home():
    return "Heart Risk API is running!"

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json

        # حساب النقاط
        score = 0

        # أعراض خطيرة
        if data['Chest_Pain']: score += 2
        if data['Shortness_of_Breath']: score += 2
        if data['Pain_Arms_Jaw_Back']: score += 2

        # أعراض متوسطة
        for key in ['Fatigue', 'Palpitations', 'Dizziness', 'Cold_Sweats_Nausea', 'Swelling']:
            if data.get(key): score += 1

        # عوامل الخطر المزمنة
        for key in ['High_BP', 'High_Cholesterol', 'Diabetes', 'Obesity', 'Smoking', 
                    'Sedentary_Lifestyle', 'Family_History', 'Chronic_Stress']:
            if data.get(key): score += 1

        # عامل السن
        if data['Age'] >= 60:
            score += 1

        # تحديد مستوى الخطورة
        if score >= 5:
            risk = "High Risk"
        elif score >= 3:
            risk = "Medium Risk"
        else:
            risk = "Low Risk"

        return jsonify({'prediction': risk})
    except Exception as e:
        return jsonify({'error': str(e)}), 500



if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)

