#' Chat History Convert
#'
#' This function converts the chat history along with a generative AI object to a valid format
#' for another generative AI object.
#'
#' @param from.genai.object A source generative AI object containing necessary and correct information.
#' @param to.genai.object A target generative AI object containing necessary and correct information.
#'
#' @return If successful, the converted chat history list will be returned.
#'
#' @details Providing accurate and valid information for each argument is crucial for successful chat
#' generation by the generative AI model. If any parameter is incorrect, the function responds with an
#' error message based on the API feedback. To view all supported generative AI models, use the
#' function \code{\link{available.models}}. Moreover, you can print out the chat history using the
#' function \code{\link{chat.history.print}} or simply use \code{verbose = TRUE} during the chat.
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/chat_history_convert.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there are two GenAI objects named 'genai.model' and 'another.genai.model'
#' # supporting this function, please refer to the "Live Demo in Colab" above for
#' # real examples. The following examples are just some basic guidelines.
#'
#' # Method 1 (recommended): use the pipe operator "%>%"
#' converted.history = genai.model %>%
#'   chat.history.convert(to.genai.object = another.genai.model)
#'
#' # Method 2: use the reference operator "$"
#' converted.history = genai.model$chat.history.convert(to.genai.object = another.genai.model)
#'
#' # Method 3: use the function chat.history.convert() directly
#' converted.history = chat.history.convert(from.genai.object = genai.model,
#'                                          to.genai.object = another.genai.model)
#' }
#'
#' @export
chat.history.convert = function(from.genai.object,
                                to.genai.object) {
  from.genai.object$chat.history.convert(from.genai.object,
                                         to.genai.object)
}
