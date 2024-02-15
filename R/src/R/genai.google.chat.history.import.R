#' @noRd
genai.google.chat.history.import = function(genai.google.object,
                                            new.chat.history) {
  # Imported chat history is a list
  if (is.list(new.chat.history)) {
    expected.format = list(
      role = NA,
      parts = list(
        text = NA
      )
    )
    for (message in new.chat.history) {
      if (!identical(names(message), names(expected.format)) ||
          !is.character(message$role) ||
          !is.list(message$parts) ||
          length(message$parts) != 1 ||
          !is.character(message$parts$text)) {
        stop("Invalid value for new.chat.history. Please make sure the format of the imported chat history is correct.")
      }
    }
    genai.google.object$chat.history$contents = new.chat.history
  }
  else {
    stop("Invalid new.chat.history. Please make sure it is a list.")
  }
}
