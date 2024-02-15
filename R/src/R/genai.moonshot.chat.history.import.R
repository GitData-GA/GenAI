#' @noRd
genai.moonshot.chat.history.import = function(genai.moonshot.object,
                                              new.chat.history) {
  # Imported chat history is a list
  if (is.list(new.chat.history)) {
    expected.format = list(
      role = NA,
      content = NA
    )
    for (message in new.chat.history) {
      if (!identical(names(message), names(expected.format)) ||
          !is.character(message$role) ||
          !is.character(message$content)) {
        stop("Invalid value for new.chat.history. Please make sure the format of the imported chat history is correct.")
      }
    }
    genai.moonshot.object$chat.history$messages = new.chat.history
  }
  else {
    stop("Invalid new.chat.history. Please make sure it is a list.")
  }
}
