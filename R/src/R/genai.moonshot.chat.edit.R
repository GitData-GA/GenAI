#' @noRd
genai.moonshot.chat.edit = function(genai.moonshot.object,
                                    prompt,
                                    message.to.edit,
                                    verbose,
                                    config = list(
                                      max.tokens = NULL,
                                      temperature = NULL,
                                      top.p = NULL
                                    )) {
  # Check if there are messages in the chat history
  if (length(genai.moonshot.object$chat.history$messages) == 0) {
    stop("Invalid chat.history. The chat history is empty.")
  }

  # Check message.to.edit with chat.history length
  if (message.to.edit > length(genai.moonshot.object$chat.history$messages) ||
      message.to.edit < 1) {
    stop(
      "Invalid value for message.to.edit. You can only edit existing messages. Please use 'chat.history.print()' to review the formatted chat history."
    )
  }

  # Check message.to.edit (must be a even number)
  if (message.to.edit %% 2 == 1) {
    stop(
      "Invalid value for message.to.edit. You can only edit messages sent by a user role. Please use 'chat.history.print()' to review the formatted chat history."
    )
  }

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
  requestNewContent = list(list(role = "user",
                                content = prompt))
  requestBody = as.list(genai.moonshot.object$chat.history)
  requestBody$messages = append(requestBody$messages[1:message.to.edit - 1],
                                requestNewContent)

  # Get the generation configuration
  if (length(config) > 0) {
    requestBody = genai.moonshot.generation.config(requestBody, config)
  }

  # Convert the request as JSON format
  requestBodyJSON = jsonlite::toJSON(c(model = genai.moonshot.object$model,
                                       requestBody),
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

  # Save the most recent prompt to the chat history
  genai.moonshot.object$chat.history$messages = append(genai.moonshot.object$chat.history$messages[1:message.to.edit - 1],
                                                       requestNewContent)

  # Save the most recent model response to the chat history
  respondContent = list(list(
    role = "assistant",
    content = responseJSON$choices[[1]]$message$content
  ))
  genai.moonshot.object$chat.history$messages = append(genai.moonshot.object$chat.history$messages,
                                                       respondContent)

  # Print detail if verbose is TRUE
  if (verbose) {
    genai.moonshot.formated.confguration(requestBody, prompt)
    cat("=============================================================================\n")
    cat("   Chat history \n")
    cat("-----------------------------------------------------------------------------\n\n")
    genai.moonshot.chat.history.print(genai.moonshot.object, from = 1, to = NULL)
    cat("=============================================================================\n\n\n\n")
  }

  # Get the response text
  return (responseJSON$choices[[1]]$message$content)
}
