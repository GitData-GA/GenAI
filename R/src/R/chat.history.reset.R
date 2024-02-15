#' Chat History Reset
#'
#' This function resets the chat history along with a generative AI object.
#'
#' @param genai.object A generative AI object containing necessary and correct information.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful chat
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/chat_history_reset.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there is a GenAI object named 'genai.model' supporting this
#' # function, please refer to the "Live Demo in Colab" above for real
#' # examples. The following examples are just some basic guidelines.
#'
#' # Method 1 (recommended): use the pipe operator "%>%"
#' genai.model %>%
#'   chat.history.reset()
#'
#' # Method 2: use the reference operator "$"
#' genai.model$chat.history.reset()
#'
#' # Method 3: use the function chat.history.reset() directly
#' chat.history.reset(genai.object = genai.model)
#' }
#'
#' @export
chat.history.reset = function(genai.object) {
  genai.object$chat.history.reset()
}
