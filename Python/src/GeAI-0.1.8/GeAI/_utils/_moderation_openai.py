import json
import requests

def moderation_openai(model_parameter, prompt):
    safety_url = (
        f"https://api.genai.gd.edu.kg/openai/{model_parameter['version']}/moderations"
        if model_parameter["proxy"]
        else f"https://api.openai.com/{model_parameter['version']}/moderations"
    )
    safety_check = {"input": prompt}
    safety_request = json.dumps(safety_check, separators=(",", ":"), ensure_ascii=False)
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {model_parameter['api']}"
    }
    safety_response = requests.post(safety_url, data=safety_request, headers=headers)
    safety_response_json = safety_response.json()
    if safety_response_json["results"][0]["flagged"]:
        raise ValueError("The prompt may contain harmful content.")