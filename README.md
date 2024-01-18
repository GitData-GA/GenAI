# GenAI API Proxy Service

For individuals utilizing Generative AI service providers with API usage location restrictions in certain countries/regions, this service is tailored for those who possess a valid API key but find themselves outside their home countries/regions due to travel, work, or study in regions not covered by some Generative AI service providers.

**How does it work?** GenAI's API proxy service functions by directing your request initially to our server located in a country/region eligible for specific Generative AI services. Subsequently, GenAI's server forwards your request to the official server of the Generative AI service provider. Once the provider's server completes processing the request, the response is sent back to GenAI's server, which then relays it back to the user's device. This process is illustrated in the accompanying image.

<img src="https://genai.gd.edu.kg/assets/img/proxy.svg" width="800px" alt="How proxy work?">

**How to use this service?**

- GenAI package in R: Set TRUE to parameter proxy in function connect.genai and use the model parameter for text generations and chat generations.

- GenAI package in Python: Under development.

- Use the proxy URL directly:

  - To proxy an API request for Google's models, substitute the original URL: Replace the original URL `https://generativelanguage.googleapis.com/` with the proxied URL `https://api.genai.gd.edu.kg/google/`.

  - To proxy an API request for OpenAI's models, substitute the original URL: Replace the original URL `https://api.openai.com/` with the proxied URL `https://api.genai.gd.edu.kg/openai/`.

It's important to note that while GenAI and its associated organization do not collect user information, the server providers for GenAI and the Generative AI service provider may do so. Additionally, the connection speed using the proxy service is not guaranteed. Users are advised to use this service at their own risk.

# License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1).
