#' @noRd
genai.openai.img = function(genai.openai.object,
                            prompt,
                            verbose,
                            config = list(
                              quality = NULL,
                              size = NULL,
                              style = NULL,
                              user = NULL
                            )) {
  # Check configurations
  genai.openai.img.config.check(config)

  # Get api url
  api.url = paste0(
    "https://api.openai.com/",
    genai.openai.object$version,
    "/images/generations"
  )
  if (genai.openai.object$proxy) {
    api.url = paste0(
      "https://api.genai.gd.edu.kg/openai/",
      genai.openai.object$version,
      "/images/generations"
    )
  }

  # Initialize the request body
  requestBody = list(
    model = genai.openai.object$model,
    prompt = prompt,
    response_format = "b64_json"
  )

  # Get the generation configuration
  if (length(config) > 0) {
    requestBody = genai.openai.img.generation.config(requestBody, config)
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
    genai.openai.img.formated.confguration(requestBody, prompt)
    cat("\n")
  }

  # Store the image
  image.data = base64enc::base64decode(responseJSON$data[[1]]$b64_json[1])
  tmp.img = tempfile(fileext = ".png")
  writeBin(image.data, tmp.img)
  export.img = ggplotify::as.ggplot(magick::image_read(tmp.img))

  # Return the image
  return (export.img)
}
