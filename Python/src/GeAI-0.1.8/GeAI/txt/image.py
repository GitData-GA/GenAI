import json
import requests
from GeAI._utils._moderation_openai import moderation_openai
from GeAI._utils._image_to_data_uri import image_to_data_uri

def image(model_parameter, temperature, prompt, image_path):
    if prompt == "" or prompt is None or not isinstance(prompt, str):
        raise ValueError("Prompt is not in the correct format.")

    if image_path == "" or image_path is None or not isinstance(image_path, str):
        raise ValueError("image_path is not in the correct format.")

    if model_parameter["provider"] == "google":
        api_url = (
            f"https://api.genai.gd.edu.kg/google/{model_parameter['version']}/models/"
            f"{model_parameter['model']}:generateContent?key={model_parameter['api']}"
            if model_parameter["proxy"]
            else f"https://generativelanguage.googleapis.com/{model_parameter['version']}/models/"
                 f"{model_parameter['model']}:generateContent?key={model_parameter['api']}"
        )

        extension, img_info = image_to_data_uri(image_path)
        if extension == "jpg":
            extension = "jpeg"

        request_body = {
            "contents": [
                {"parts": [{"text": prompt}, {"inline_data": {"mime_type": f"image/{extension}", "data": img_info}}]}
            ],
            "generationConfig": {"temperature": temperature}
        }

        request_body_json = json.dumps(request_body, separators=(",", ":"), ensure_ascii=False)
        headers = {"Content-Type": "application/json"}
        response = requests.post(api_url, data=request_body_json, headers=headers)

        response_json = response.json()
        if "error" in response_json:
            raise ValueError(response_json["error"]["message"])

        if "blockReason" in response_json.get("promptFeedback", {}):
            raise ValueError("The prompt may contain harmful content.")

        return str(response_json["candidates"][0]["content"]["parts"][0]["text"])

    elif model_parameter["provider"] == "openai":
        moderation_openai(model_parameter, prompt)
        api_url = (
            f"https://api.genai.gd.edu.kg/openai/{model_parameter['version']}/chat/completions"
            if model_parameter["proxy"]
            else f"https://api.openai.com/{model_parameter['version']}/chat/completions"
        )

        extension, img_info = image_to_data_uri(image_path)
        request_body = {
            "model": model_parameter["model"],
            "messages": [
                {"role": "user", "content": [
                    {"type": "text", "text": prompt},
                    {"type": "image_url", "image_url": {"url": f"data:image/{extension};base64,{img_info}"}}]
                }
            ],
            "temperature": temperature,
            "max_tokens": 4096
        }

        request_body_json = json.dumps(request_body, separators=(",", ":"), ensure_ascii=False)
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {model_parameter['api']}"
        }

        response = requests.post(api_url, data=request_body_json, headers=headers)

        response_json = response.json()
        if "error" in response_json:
            raise ValueError(response_json["error"]["message"])

        return str(response_json["choices"][0]["message"]["content"])
    else:
        raise ValueError("Invalid provider")