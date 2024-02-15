#' @noRd
genai.moonshot.chat.history.print = function(genai.moonshot.object,
                                             from,
                                             to) {
  if (!is.numeric(from) || from < 1) {
    stop("Invalid value for from. It should be an integer greater than or equal to 1.")
  }

  if (is.numeric(to) && to < from) {
    stop("Invalid value for to. It should be an integer greater than or equal to from")
  }

  chat.length = length(genai.moonshot.object$chat.history$messages)

  if (is.numeric(to) && to > chat.length) {
    stop("Invalid value for to. It should be an integer less than or equal to ", chat.length, ".")
  }

  if (is.numeric(to)) {
    chat.length = to
  }

  if (chat.length > 0) {
    for (i in from:chat.length) {
      cat(
        sprintf(
          "-------------------------------- Message %2d ---------------------------------\n",
          i
        )
      )
      cat("Role:",
          genai.moonshot.object$chat.history$messages[[i]]$role,
          "\n")
      cat("Text: ")
      cat(paste(strwrap(genai.moonshot.object$chat.history$messages[[i]]$content,
                        width = 76, exdent = 0), collapse = "\n"))
      cat("\n\n")
    }
  }
}
