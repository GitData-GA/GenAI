#' @noRd
genai.google.chat.history.save = function(genai.google.object,
                                          file.name) {
  write(jsonlite::toJSON(genai.google.object$chat.history$contents, pretty = TRUE),
        paste0(file.name, ".json"))
}
