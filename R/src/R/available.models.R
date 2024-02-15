#' Get Supported Generative AI Models
#'
#' This function sends a request to GenAI database API to retrieve information
#' about available generative AI models.
#'
#' @return If successful, the function returns a list containing generative AI
#' service providers and their corresponding models. If the function encounters an error,
#' it will halt execution and provide an error message.
#'
#' @details
#' The function utilizes the GenAI database API to fetch the latest information about
#' available Generative AI models. The retrieved data includes details about different models
#' offered by various service providers.
#'
#' @seealso
#' \href{https://genai.gd.edu.kg/r/documentation/}{GenAI - R Package "GenAI" Documentation}
#'
#' \href{https://colab.research.google.com/github/GitData-GA/GenAI/blob/gh-pages/r/example/available_models.ipynb}{Live Demo in Colab}
#'
#' @examples
#' \dontrun{
#' # Assuming there is a GenAI object named 'genai.model' supporting this
#' # function, please refer to the "Live Demo in Colab" above for real
#' # examples. The following examples are just some basic guidelines.
#'
#' all.models = available.models() %>% print()
#' }
#'
#' @export
available.models = function() {
  json.data = jsonlite::fromJSON("https://genai.gd.edu.kg/model.json")
  return (json.data)
}
