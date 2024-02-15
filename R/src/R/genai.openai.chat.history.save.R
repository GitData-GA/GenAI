#' @noRd
genai.openai.chat.history.save = function(genai.openai.object,
                                          file.name) {
  write(jsonlite::toJSON(genai.openai.object$chat.history$messages, pretty = TRUE),
        paste0(file.name, ".json"))
}
