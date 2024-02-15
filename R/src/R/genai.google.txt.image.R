#' @noRd
genai.google.txt.image = function(genai.google.object,
                                  prompt,
                                  image.path,
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

  # Convert image to data uri
  img.info = image.to.data.uri(image.path)
  if (img.info[1] == "jpg") {
    img.info[1] = "jpeg"
  }

  # Initialize the request body
  requestBody = list(contents = list(parts = list(
    list(text = prompt),
    list(inline_data = list(
      mime_type = paste0("image/", img.info[1]),
      data = img.info[2]
    ))
  )))

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

  # Print detail if verbose is TRUE
  if (verbose) {
    genai.google.formated.confguration(requestBody, prompt)
    cat("=============================================================================\n")
    cat("   Image Path\n")
    cat("-----------------------------------------------------------------------------\n")
    cat(paste(strwrap(image.path, width = 76, exdent = 0), collapse = "\n"))
    cat("\n")
    cat("=============================================================================\n\n\n\n")
    cat("\n")
  }

  # Get the response text
  return (responseJSON$candidates[[1]]$content$parts[[1]]$text)
}
