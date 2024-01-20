import requests
import base64

def image_to_data_uri(image_path):
    image_data = ""
    
    if image_path.lower().startswith(("http://", "https://")):
        response = requests.get(image_path)
        response.raise_for_status()
        image_data = base64.b64encode(response.content).decode("utf-8")
    else:
        with open(image_path, "rb") as image_file:
            image_data = base64.b64encode(image_file.read()).decode("utf-8")

    extension = image_path.split(".")[-1].lower()
    return extension, image_data