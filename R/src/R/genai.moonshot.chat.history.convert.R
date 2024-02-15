#' @noRd
genai.moonshot.chat.history.convert = function(from.genai.moonshot.object,
                                               to.genai.object) {
  if (class(to.genai.object)[1] == "genai.google") {
    moonshot.history = from.genai.moonshot.object$chat.history$messages[2:length(from.genai.moonshot.object$chat.history$messages)]
    contents = lapply(moonshot.history, function(entry) {
      list(
        role = ifelse(entry$role == "assistant", "model", "user"),
        parts = list(text = entry$content)
      )
    })
    google.history = contents
    return(google.history)
  }
  else if (class(to.genai.object)[1] == "genai.openai") {
    openai.history = from.genai.moonshot.object$chat.history$messages
    openai.history[[1]]$content = "You are a helpful assistant."
    return(openai.history)
  }
  else {
    stop("Invalid value for to.genai.object.")
  }
}
