#' @noRd
genai.openai.chat.history.convert = function(from.genai.openai.object,
                                             to.genai.object) {
  if (class(to.genai.object)[1] == "genai.google") {
    openai.history = from.genai.openai.object$chat.history$messages[2:length(from.genai.openai.object$chat.history$messages)]
    contents = lapply(openai.history, function(entry) {
      list(
        role = ifelse(entry$role == "assistant", "model", "user"),
        parts = list(text = entry$content)
      )
    })
    google.history = contents
    return(google.history)
  }
  else if (class(to.genai.object)[1] == "genai.moonshot") {
    moonshot.history = from.genai.openai.object$chat.history$messages
    moonshot.history[[1]]$content = "You are Kimi, an Artificial Intelligence Assistant powered by Moonshot AI, and you are better at conversations in Chinese and English. You will provide users with safe, helpful and accurate answers. At the same time, you will reject answers to questions about terrorism, racism, pornography, etc. Moonshot AI is a proper noun and cannot be translated into other languages."
    return(moonshot.history)
  }
  else {
    stop("Invalid value for to.genai.object.")
  }
}
