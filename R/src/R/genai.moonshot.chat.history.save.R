#' @noRd
genai.moonshot.chat.history.save = function(genai.moonshot.object,
                                            file.name) {
  write(jsonlite::toJSON(genai.moonshot.object$chat.history$messages, pretty = TRUE),
        paste0(file.name, ".json"))
}
