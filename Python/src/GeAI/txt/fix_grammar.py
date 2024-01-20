import json
import requests
from GeAI._utils._moderation_openai import moderation_openai

def fix_grammar(model_parameter, temperature, prompt):
    if prompt == "" or prompt is None or not isinstance(prompt, str):
        raise ValueError("Prompt is not in correct format.")
    provider = model_parameter["provider"]
    if provider == "google":
        api_url = (
            f"https://api.genai.gd.edu.kg/google/{model_parameter['version']}/models/"
            f"{model_parameter['model']}:generateContent?key={model_parameter['api']}"
            if model_parameter["proxy"]
            else f"https://generativelanguage.googleapis.com/{model_parameter['version']}/models/"
                 f"{model_parameter['model']}:generateContent?key={model_parameter['api']}"
        )
        request_body = {
            "contents": {"parts": [{"text": f"Rewrite the following text and fix any grammar issues:\n # Text starts #\n{prompt}\n# Text ends #\n"}]},
            "generationConfig": {"temperature": temperature}
        }
        headers = {"Content-Type": "application/json"}

        request_body_json = json.dumps(request_body, separators=(",", ":"), ensure_ascii=False)
        response = requests.post(api_url, data=request_body_json, headers=headers)
        response_json = response.json()

        if "error" in response_json:
          raise ValueError(response_json["error"]["message"])

        if "blockReason" in response_json.get("promptFeedback", {}):
          raise ValueError("The prompt may contain harmful content.")

        return str(response_json["candidates"][0]["content"]["parts"][0]["text"])
    elif provider == "openai":
        moderation_openai(model_parameter, prompt)
        api_url = (
            f"https://api.genai.gd.edu.kg/openai/{model_parameter['version']}/chat/completions"
            if model_parameter["proxy"]
            else f"https://api.openai.com/{model_parameter['version']}/chat/completions"
        )
        request_body = {
            "model": model_parameter["model"],
            "messages": [
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": f"Rewrite the following text and fix any grammar issues:\n # Text starts #\n{prompt}\n# Text ends #\n"}
            ],
            "temperature": temperature
        }
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {model_parameter['api']}"
        }

        request_body_json = json.dumps(request_body, separators=(",", ":"), ensure_ascii=False)
        response = requests.post(api_url, data=request_body_json, headers=headers)
        response_json = response.json()

        if "error" in response_json:
          raise ValueError(response_json["error"]["message"])

        return str(response_json["choices"][0]["message"]["content"])
    else:
        raise ValueError("Invalid provider")