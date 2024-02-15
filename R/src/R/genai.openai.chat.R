#' @noRd
genai.openai.chat = function(genai.openai.object,
                             prompt,
                             verbose,
                             config = list(
                               frequency.penalty = NULL,
                               logit.bias = NULL,
                               logprobs = NULL,
                               top.logprobs = NULL,
                               max.tokens = NULL,
                               presence.penalty = NULL,
                               response.format = NULL,
                               seed = NULL,
                               stop = NULL,
                               temperature = NULL,
                               top.p = NULL,
                               tools = NULL,
                               tool.choice = NULL,
                               user = NULL
                             )) {
  # Check configurations
  genai.openai.config.check(config)

  # Get api url
  api.url = paste0(
    "https://api.openai.com/",
    genai.openai.object$version,
    "/chat/completions"
  )
  if (genai.openai.object$proxy) {
    api.url = paste0(
      "https://api.genai.gd.edu.kg/openai/",
      genai.openai.object$version,
      "/chat/completions"
    )
  }

  # Initialize the request body
  requestNewContent = list(list(role = "user",
                                content = prompt))
  requestBody = as.list(genai.openai.object$chat.history)
  requestBody$messages = append(requestBody$messages, requestNewContent)

  # Get the generation configuration
  if (length(config) > 0) {
    requestBody = genai.openai.generation.config(requestBody, config)
  }

  # Convert the request as JSON format
  requestBodyJSON = jsonlite::toJSON(c(model = genai.openai.object$model,
                                       requestBody),
                                     auto_unbox = TRUE,
                                     pretty = TRUE)

  # Send request and get response
  response = httr::POST(
    url = api.url,
    body = requestBodyJSON,
    httr::add_headers(
      "Content-Type" = "application/json",
      "Authorization" = paste("Bearer", genai.openai.object$api)
    )
  )
  if (!is.null(genai.openai.object$organization.id) &&
      is.character(genai.openai.object$organization.id)) {
    response = httr::POST(
      url = api.url,
      body = requestBodyJSON,
      httr::add_headers(
        "Content-Type" = "application/json",
        "Authorization" = paste("Bearer", genai.openai.object$api),
        "OpenAI-Organization" = genai.openai.object$organization.id
      )
    )
  }
  responseJSON = httr::content(response, "parsed")

  # Check for response error
  if (!is.null(responseJSON$error)) {
    stop(responseJSON$error$message)
  }

  # Save the most recent prompt to the chat history
  genai.openai.object$chat.history$messages = append(genai.openai.object$chat.history$messages,
                                                     requestNewContent)

  # Save the most recent model response to the chat history
  respondContent = list(list(
    role = "assistant",
    content = responseJSON$choices[[1]]$message$content
  ))
  genai.openai.object$chat.history$messages = append(genai.openai.object$chat.history$messages,
                                                     respondContent)

  # Print detail if verbose is TRUE
  if (verbose) {
    genai.openai.formated.confguration(requestBody, prompt)
    cat("=============================================================================\n")
    cat("   Chat history \n")
    cat("-----------------------------------------------------------------------------\n\n")
    genai.openai.chat.history.print(genai.openai.object, from = 1, to = NULL)
    cat("=============================================================================\n\n\n\n")
  }

  # Get the response text
  return (responseJSON$choices[[1]]$message$content)
}
