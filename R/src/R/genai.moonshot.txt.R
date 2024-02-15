#' @noRd
genai.moonshot.txt = function(genai.moonshot.object,
                              prompt,
                              verbose,
                              config = list(
                                max.tokens = NULL,
                                temperature = NULL,
                                top.p = NULL
                              )) {
  # Check configurations
  genai.moonshot.config.check(config)

  # Get api url
  api.url = paste0(
    "https://api.moonshot.cn/",
    genai.moonshot.object$version,
    "/chat/completions"
  )
  if (genai.moonshot.object$proxy) {
    api.url = paste0(
      "https://api.genai.gd.edu.kg/moonshot/",
      genai.moonshot.object$version,
      "/chat/completions"
    )
  }

  # Initialize the request body
  requestBody = list(
    model = genai.moonshot.object$model,
    messages = list(
      list(role = "system",
           content = "You are Kimi, an Artificial Intelligence Assistant powered by Moonshot AI, and you are better at conversations in Chinese and English. You will provide users with safe, helpful and accurate answers. At the same time, you will reject answers to questions about terrorism, racism, pornography, etc. Moonshot AI is a proper noun and cannot be translated into other languages."),
      list(role = "user",
           content = prompt)
    )
  )

  # Get the generation configuration
  if (length(config) > 0) {
    requestBody = genai.moonshot.generation.config(requestBody, config)
  }

  # Convert the request as JSON format
  requestBodyJSON = jsonlite::toJSON(requestBody,
                                     auto_unbox = TRUE,
                                     pretty = TRUE)

  # Send request and get response
  response = httr::POST(
    url = api.url,
    body = requestBodyJSON,
    httr::add_headers(
      "Content-Type" = "application/json",
      "Authorization" = paste("Bearer", genai.moonshot.object$api)
    )
  )
  responseJSON = httr::content(response, "parsed")

  # Check for response error
  if (!is.null(responseJSON$error)) {
    stop(responseJSON$error$message)
  }

  # Print detail if verbose is TRUE
  if (verbose) {
    genai.moonshot.formated.confguration(requestBody, prompt)
    cat("\n")
  }

  # Get the response text
  return (responseJSON$choices[[1]]$message$content)
}
