#' @noRd
moderation.openai = function(model.parameter, prompt) {
  safety.URL = ifelse(
    model.parameter["proxy"],
    paste0(
      "https://api.genai.gd.edu.kg/openai/",
      model.parameter["version"],
      "/moderations"
    ),
    paste0(
      "https://api.openai.com/",
      model.parameter["version"],
      "/moderations"
    )
  )
  safety.check = list(input = prompt)
  safety.request = jsonlite::toJSON(safety.check, auto_unbox = TRUE)
  safety.response = httr::POST(
    url = safety.URL,
    body = safety.request,
    httr::add_headers(
      "Content-Type" = "application/json",
      "Authorization" = paste("Bearer", model.parameter["api"])
    )
  )
  safety.responseJSON = httr::content(safety.response, "parsed")
  if (safety.responseJSON$results[[1]]$flagged) {
    stop("Safety: The prompt may contain harmful content.")
  }
}

#' @noRd
image.to.data.uri = function(image.path) {
  image.data = ""
  if (grepl("^https?://", tolower(image.path))) {
    response = httr::GET(image.path)
    image.data = base64enc::base64encode(httr::content(response, type = "raw"))
  } else {
    image.data = base64enc::base64encode(readBin(image.path, "raw", file.info(image.path)$size))
  }
  return(c(tools::file_ext(image.path), image.data))
}

#' @noRd
chat.convert.google.to.openai = function(google.history, openai.model) {
  system.message = list(role = "system", content = "You are a helpful assistant.")
  messages = lapply(google.history$contents, function(entry) {
    list(
      role = ifelse(entry$role == "model", "assistant", "user"),
      content = entry$parts$text
    )
  })
  openai.history = list(model = openai.model["model"],
                        messages = c(list(system.message),
                                     messages))
  return(openai.history)
}

#' @noRd
chat.convert.openai.to.google = function(openai.history, google.model) {
  openai.history$messages = openai.history$messages[2:length(openai.history$messages)]
  contents = lapply(openai.history$messages, function(entry) {
    list(
      role = ifelse(entry$role == "assistant", "model", "user"),
      parts = list(text = entry$content)
    )
  })
  google.history = list(contents = c(contents))
  return(google.history)
}
