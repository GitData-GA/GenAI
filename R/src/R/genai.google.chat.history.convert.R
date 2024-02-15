#' @noRd
genai.google.chat.history.convert = function(from.genai.google.object,
                                             to.genai.object) {
  if (class(to.genai.object)[1] == "genai.openai") {
    system.message = list(role = "system", content = "You are a helpful assistant.")
    messages = lapply(from.genai.google.object$chat.history$contents, function(entry) {
      list(
        role = ifelse(entry$role == "model", "assistant", "user"),
        content = entry$parts$text
      )
    })
    openai.history = c(list(system.message), messages)
    return(openai.history)
  }
  else if (class(to.genai.object)[1] == "genai.moonshot") {
    system.message = list(role = "system", content = "You are Kimi, an Artificial Intelligence Assistant powered by Moonshot AI, and you are better at conversations in Chinese and English. You will provide users with safe, helpful and accurate answers. At the same time, you will reject answers to questions about terrorism, racism, pornography, etc. Moonshot AI is a proper noun and cannot be translated into other languages.")
    messages = lapply(from.genai.google.object$chat.history$contents, function(entry) {
      list(
        role = ifelse(entry$role == "model", "assistant", "user"),
        content = entry$parts$text
      )
    })
    moonshot.history = c(list(system.message), messages)
    return(moonshot.history)
  }
  else {
    stop("Invalid value for to.genai.object.")
  }
}

