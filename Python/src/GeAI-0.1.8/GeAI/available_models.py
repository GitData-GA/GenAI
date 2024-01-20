import json
import requests

def available_models():
    response = requests.get("https://genai.gd.edu.kg/model.json")
    if response.status_code == 200:
        json_data = response.json()
        return json_data
    else:
        print(f"Failed to fetch data. Status code: {response.status_code}")
        return None