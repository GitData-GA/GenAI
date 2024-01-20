import json
import requests

def connect(provider, model, version, api, proxy = False):
    response = requests.get("https://genai.gd.edu.kg/model.json")
    json_data = response.json()
    if provider == "google":
        version = next(arg for arg in [version] if arg in json_data["google"]["version"])
        model = next(arg for arg in [model] if arg in json_data["google"]["model"])
        api_url = (
            f"https://api.genai.gd.edu.kg/google/{version}/models/{model}?key={api}"
            if proxy
            else f"https://generativelanguage.googleapis.com/{version}/models/{model}?key={api}"
        )
        response = requests.get(api_url, headers={"Content-Type": "application/json"})
    elif provider == "openai":
        version = next(arg for arg in [version] if arg in json_data["openai"]["version"])
        model = next(arg for arg in [model] if arg in json_data["openai"]["model"])
        api_url = (
            f"https://api.genai.gd.edu.kg/openai/{version}/models"
            if proxy
            else f"https://api.openai.com/{version}/models"
        )
        response = requests.get(api_url, headers={"Content-Type": "application/json", "Authorization": f"Bearer {api}"})
    else:
        raise ValueError("Invalid provider")
    response_json = response.json()
    if "error" in response_json and response_json["error"] is not None:
        raise ValueError(response_json["error"]["message"])
    return {
        "provider": provider,
        "model": model,
        "version": version,
        "api": api,
        "proxy": proxy
    }