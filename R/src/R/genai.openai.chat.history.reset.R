#' @noRd
genai.openai.chat.history.reset = function(genai.openai.object) {
  genai.openai.object$chat.history$messages = list(
    list(
      role = "system",
      content = "You are a helpful assistant."
    )
  )
}
