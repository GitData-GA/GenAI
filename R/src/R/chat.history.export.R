#' Chat History Export
#'
#' This function exports the chat history along with a generative AI object as a list.
#'
#' @param genai.object A generative AI object containing necessary and correct information.
#'
#' @return If successful, the chat history list will be returned.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful chat
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/chat_history_export.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there is a GenAI object named 'genai.model' supporting this
#' # function, please refer to the "Live Demo in Colab" above for real
#' # examples. The following examples are just some basic guidelines.
#'
#' # Method 1 (recommended): use the pipe operator "%>%"
#' exported.history = genai.model %>%
#'   chat.history.export()
#'
#' # Method 2: use the reference operator "$"
#' exported.history = genai.model$chat.history.export()
#'
#' # Method 3: use the function chat.history.export() directly
#' exported.history = chat.history.export(genai.object = genai.model)
#' }
#'
#' @export
chat.history.export = function(genai.object) {
  genai.object$chat.history.export()
}
