#' @noRd
genai.google.chat = function(genai.google.object,
                             prompt,
                             verbose,
                             config = list(
                               harm.category.dangerous.content = NULL,
                               harm.category.harassment = NULL,
                               harm.category.hate.speech = NULL,
                               harm.category.sexually.explicit = NULL,
                               stop.sequences = NULL,
                               max.output.tokens = NULL,
                               temperature = NULL,
                               top.p = NULL,
                               top.k = NULL
                             )) {
  # Check configurations
  genai.google.config.check(config)

  # Get api url
  api.url = paste0(
    "https://generativelanguage.googleapis.com/",
    genai.google.object$version,
    "/models/",
    genai.google.object$model,
    ":generateContent?key=",
    genai.google.object$api
  )
  if (genai.google.object$proxy) {
    api.url = paste0(
      "https://api.genai.gd.edu.kg/google/",
      genai.google.object$version,
      "/models/",
      genai.google.object$model,
      ":generateContent?key=",
      genai.google.object$api
    )
  }

  # Initialize the request body
  requestNewContent = list(list(role = "user",
                                parts = list(text = prompt)))
  requestBody = as.list(genai.google.object$chat.history)
  requestBody$contents = append(requestBody$contents, requestNewContent)

  # Get the safety settings
  safety.setting = genai.google.safety.setting(config)
  if (length(safety.setting) > 0) {
    requestBody$safetySettings = safety.setting
  }

  # Get the generation configuration
  generation.config = genai.google.generation.config(config)
  if (length(generation.config) > 0) {
    requestBody$generationConfig = generation.config
  }

  # Convert the request as JSON format
  requestBodyJSON = jsonlite::toJSON(requestBody,
                                     auto_unbox = TRUE,
                                     pretty = TRUE)

  # Send request and get response
  response = httr::POST(
    url = api.url,
    body = requestBodyJSON,
    httr::add_headers("Content-Type" = "application/json")
  )
  responseJSON = httr::content(response, "parsed")

  # Check for harmful prompt
  if (!is.null(responseJSON$promptFeedback$blockReason)) {
    stop("Invalid prompt. The prompt may contain harmful content.")
  }

  # Check for response error
  if (!is.null(responseJSON$error)) {
    stop(responseJSON$error$message)
  }

  # Save the most recent prompt to the chat history
  genai.google.object$chat.history$contents = append(genai.google.object$chat.history$contents,
                                                     requestNewContent)

  # Save the most recent model response to the chat history
  respondContent = list(list(
    role = "model",
    parts = list(text = responseJSON$candidates[[1]]$content$parts[[1]]$text)
  ))
  genai.google.object$chat.history$contents = append(genai.google.object$chat.history$contents,
                                                     respondContent)

  # Print detail if verbose is TRUE
  if (verbose) {
    genai.google.formated.confguration(requestBody, prompt)
    cat("=============================================================================\n")
    cat("   Chat history \n")
    cat("-----------------------------------------------------------------------------\n\n")
    genai.google.chat.history.print(genai.google.object, from = 1, to = NULL)
    cat("=============================================================================\n\n\n\n")
  }

  # Get the response text
  return (responseJSON$candidates[[1]]$content$parts[[1]]$text)
}
