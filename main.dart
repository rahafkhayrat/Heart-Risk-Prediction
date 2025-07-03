import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(HeartRiskApp());
}

class HeartRiskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heart Risk Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Segoe UI',
        colorScheme: ColorScheme.light(
          primary: Colors.redAccent,
          secondary: Colors.deepOrangeAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: Size(double.infinity, 50),
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: HeartRiskForm(),
    );
  }
}

class HeartRiskForm extends StatefulWidget {
  @override
  _HeartRiskFormState createState() => _HeartRiskFormState();
}

class _HeartRiskFormState extends State<HeartRiskForm> {
  final _formKey = GlobalKey<FormState>();

  int age = 30;
  bool chestPain = false;
  bool shortnessOfBreath = false;
  bool painArmsJawBack = false;

  bool fatigue = false;
  bool palpitations = false;
  bool dizziness = false;
  bool coldSweatsNausea = false;
  bool swelling = false;

  bool highBP = false;
  bool highCholesterol = false;
  bool diabetes = false;
  bool obesity = false;
  bool smoking = false;
  bool sedentaryLifestyle = false;
  bool familyHistory = false;
  bool chronicStress = false;

  bool isLoading = false;
  String? predictionResult;

  Future<void> predictRisk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      predictionResult = null;
    });

    final url = Uri.parse('http://127.0.0.1:5000/predict');

    Map<String, dynamic> payload = {
      "Age": age,
      "Chest_Pain": chestPain,
      "Shortness_of_Breath": shortnessOfBreath,
      "Pain_Arms_Jaw_Back": painArmsJawBack,
      "Fatigue": fatigue,
      "Palpitations": palpitations,
      "Dizziness": dizziness,
      "Cold_Sweats_Nausea": coldSweatsNausea,
      "Swelling": swelling,
      "High_BP": highBP,
      "High_Cholesterol": highCholesterol,
      "Diabetes": diabetes,
      "Obesity": obesity,
      "Smoking": smoking,
      "Sedentary_Lifestyle": sedentaryLifestyle,
      "Family_History": familyHistory,
      "Chronic_Stress": chronicStress,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          predictionResult = data['prediction'];
        });
      } else {
        setState(() {
          predictionResult = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    Color? activeColor,
  }) {
    return SwitchListTile(
      title: Row(
        children: [
          Icon(icon, size: 22, color: Colors.grey[800]),
          SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? Colors.redAccent,
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Risk Prediction'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // وصف بسيط
              Text(
                'Predict your heart disease risk based on symptoms and risk factors — simple, fast, and reliable.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // السن
              TextFormField(
                initialValue: age.toString(),
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(
                    Icons.cake_outlined,
                    color: Colors.redAccent,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter age';
                  }
                  int? v = int.tryParse(val);
                  if (v == null || v <= 0 || v > 120) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
                onChanged: (val) {
                  final v = int.tryParse(val);
                  if (v != null) {
                    setState(() {
                      age = v;
                    });
                  }
                },
              ),

              sectionTitle('Severe Symptoms', Colors.redAccent),
              buildSwitch(
                title: 'Chest Pain',
                icon: Icons.warning_amber_rounded,
                value: chestPain,
                onChanged: (val) => setState(() => chestPain = val),
                activeColor: Colors.redAccent,
              ),
              buildSwitch(
                title: 'Shortness of Breath',
                icon: Icons.air,
                value: shortnessOfBreath,
                onChanged: (val) => setState(() => shortnessOfBreath = val),
                activeColor: Colors.redAccent,
              ),
              buildSwitch(
                title: 'Pain in Arms, Jaw, Back',
                icon: Icons.accessibility_new_rounded,
                value: painArmsJawBack,
                onChanged: (val) => setState(() => painArmsJawBack = val),
                activeColor: Colors.redAccent,
              ),

              sectionTitle('Moderate Symptoms', Colors.deepOrange),
              buildSwitch(
                title: 'Fatigue',
                icon: Icons.battery_alert_rounded,
                value: fatigue,
                onChanged: (val) => setState(() => fatigue = val),
                activeColor: Colors.deepOrange,
              ),
              buildSwitch(
                title: 'Palpitations',
                icon: Icons.favorite_border,
                value: palpitations,
                onChanged: (val) => setState(() => palpitations = val),
                activeColor: Colors.deepOrange,
              ),
              buildSwitch(
                title: 'Dizziness',
                icon: Icons.sync_problem_rounded,
                value: dizziness,
                onChanged: (val) => setState(() => dizziness = val),
                activeColor: Colors.deepOrange,
              ),
              buildSwitch(
                title: 'Cold Sweats / Nausea',
                icon: Icons.ac_unit_rounded,
                value: coldSweatsNausea,
                onChanged: (val) => setState(() => coldSweatsNausea = val),
                activeColor: Colors.deepOrange,
              ),
              buildSwitch(
                title: 'Swelling',
                icon: Icons.opacity_rounded,
                value: swelling,
                onChanged: (val) => setState(() => swelling = val),
                activeColor: Colors.deepOrange,
              ),

              sectionTitle('Chronic Risk Factors', Colors.blueAccent),
              buildSwitch(
                title: 'High Blood Pressure',
                icon: Icons.speed,
                value: highBP,
                onChanged: (val) => setState(() => highBP = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'High Cholesterol',
                icon: Icons.scatter_plot_rounded,
                value: highCholesterol,
                onChanged: (val) => setState(() => highCholesterol = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'Diabetes',
                icon: Icons.medication_liquid_rounded,
                value: diabetes,
                onChanged: (val) => setState(() => diabetes = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'Obesity',
                icon: Icons.monitor_weight_rounded,
                value: obesity,
                onChanged: (val) => setState(() => obesity = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'Smoking',
                icon: Icons.smoke_free,
                value: smoking,
                onChanged: (val) => setState(() => smoking = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'Sedentary Lifestyle',
                icon: Icons.chair_alt_rounded,
                value: sedentaryLifestyle,
                onChanged: (val) => setState(() => sedentaryLifestyle = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'Family History',
                icon: Icons.family_restroom_rounded,
                value: familyHistory,
                onChanged: (val) => setState(() => familyHistory = val),
                activeColor: Colors.blueAccent,
              ),
              buildSwitch(
                title: 'Chronic Stress',
                icon: Icons.self_improvement_rounded,
                value: chronicStress,
                onChanged: (val) => setState(() => chronicStress = val),
                activeColor: Colors.blueAccent,
              ),

              SizedBox(height: 30),

              isLoading
                  ? CircularProgressIndicator(color: Colors.redAccent)
                  : ElevatedButton.icon(
                      onPressed: predictRisk,
                      icon: Icon(Icons.favorite, color: Colors.white),
                      label: Text(
                        'Predict Risk',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

              SizedBox(height: 30),

              if (predictionResult != null)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  color: predictionResult == "High Risk"
                      ? Colors.red[100]
                      : predictionResult == "Medium Risk"
                      ? Colors.orange[100]
                      : Colors.green[100],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: Text(
                      'Prediction: $predictionResult',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: predictionResult == "High Risk"
                            ? Colors.red[900]
                            : predictionResult == "Medium Risk"
                            ? Colors.orange[900]
                            : Colors.green[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
