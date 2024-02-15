#' Chat History Import
#'
#' This function imports a chat history in list format to a generative AI object.
#'
#' @param genai.object A generative AI object containing necessary and correct information.
#' @param new.chat.history A list containing a chat history in correct format.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful chat
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}.
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/chat_history_import.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there is a GenAI object named 'genai.model' supporting this
#' # function and a valid chat history list named 'new.history', please
#' # refer to the "Live Demo in Colab" above for real examples. The
#' # following examples are just some basic guidelines.
#'
#' # Method 1 (recommended): use the pipe operator "%>%"
#' genai.model %>%
#'   chat.history.import(new.chat.history = new.history)
#'
#' # Method 2: use the reference operator "$"
#' genai.model$chat.history.import(new.chat.history = new.history)
#'
#' # Method 3: use the function chat.history.import() directly
#' chat.history.import(genai.object = genai.model,
#'                     new.chat.history = new.history)
#' }
#'
#' @export
chat.history.import = function(genai.object,
                               new.chat.history) {
  genai.object$chat.history.import(new.chat.history)
}
