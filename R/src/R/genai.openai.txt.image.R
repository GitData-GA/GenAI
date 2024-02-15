#' @noRd
genai.openai.txt.image = function(genai.openai.object,
                                  prompt,
                                  image.path,
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

  # Convert image to base64 code
  img.info = image.to.data.uri(image.path)

  # Initialize the request body
  requestBody = list(model = genai.openai.object$model,
                     messages = list(
                       list(role = "system",
                            content = "You are a helpful assistant."),
                       list(role = "user",
                            content = list(
                              list(type = "text",
                                   text = prompt),
                              list(type = "image_url",
                                   image_url = list(
                                     url = paste0("data:image/",
                                                  img.info[1],
                                                  ";base64,",
                                                  img.info[2])
                                   ))
                            ))
                     ))

  # Get the generation configuration
  if (length(config) > 0) {
    requestBody = genai.openai.generation.config(requestBody, config)
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

  # Print detail if verbose is TRUE
  if (verbose) {
    genai.openai.formated.confguration(requestBody, prompt)
    cat("=============================================================================\n")
    cat("   Image Path\n")
    cat("-----------------------------------------------------------------------------\n")
    cat(paste(strwrap(image.path, width = 76, exdent = 0), collapse = "\n"))
    cat("\n")
    cat("=============================================================================\n\n\n\n")
    cat("\n")
  }

  # Get the response text
  return (responseJSON$choices[[1]]$message$content)
}
