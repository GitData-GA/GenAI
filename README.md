# GenAI - Generative Artificial Intelligence Toolbox

<img src="https://genai.gd.edu.kg/assets/img/logo.jpg" width="300px" alt="Logo">

[GenAI for R](https://cran.r-project.org/package=GenAI)   |    [GenAI Doc for R](https://genai.gd.edu.kg/r/documentation/)

Now, you can seamlessly utilize both ChatGPT from OpenAI and Gemini Pro from Google! Enjoy enhanced chat conversion and the ability to engage in multiple chat sessions with ease!

GenAI harnesses the power of advanced models like GPT-4 and Gemini Pro to serve as versatile coding and writing assistants for users in both R and, soon, Python. This toolbox empowers users with a range of capabilities, including text generation, code optimization, natural language processing, chat assistance, and image interpretation. The ultimate objective is to simplify and enhance the coding and language processing experience for users of both R and Python.

# Overview

The following image is a flowchart that describes how to use the GenAI package to generate text and chat. The flowchart starts with the user importing the GenAI package into their R or Python environment. The user is then prompted to connect to the Generative AI service providers' APIs with or without GenAI's API proxy service. If the user is successful in connecting to the API, they will be able to use the GenAI functions to generate text and chat.

<img src="https://genai.gd.edu.kg/assets/img/overview.svg" width="800px" alt="How GenAI works?">

The GenAI package provides a variety of functions for generating text, including functions for generating text explanations of code, fixing grammar, optimizing code, and generating images from text. The package also provides a variety of functions for generating chat, including functions for editing chat, converting chat to text, and setting up chat.

The output of the GenAI package is a text or chat response. The response is generated using the user's input and the GenAI functions.

# Prerequisites

1. Prior to utilizing the GenAI package, several prerequisites must be met.

2. Ensure that you possess an eligible device equipped with either R or Python.

3. Access to the internet is essential to generate text or engage in chat through GenAI.

4. Obtain an API key from the selected Generative AI service provider. GenAI currently supports Generative AI models from both Google and OpenAI.

  - To acquire an API key for Google's models, refer to: [Get an API key](https://ai.google.dev/tutorials/setup)

  - To acquire an API key for OpenAI's models, refer to: [Account setup](https://platform.openai.com/docs/quickstart/account-setup?context=python)

# API Proxy Service

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
