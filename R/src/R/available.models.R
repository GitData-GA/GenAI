#' Get supported Generative AI models
#'
#' This function sends a request to GenAI database API
#' to retrieve information about available Generative AI models.
#'
#' @return If successful, the function returns a list containing Generative AI
#' service providers and their corresponding models. If the function encounters an error,
#' it will halt execution and provide an error message.
#'
#' @details
#' The function utilizes the GenAI database API to fetch the latest information about
#' available Generative AI models. The retrieved data includes details about different models
#' offered by various service providers.
#'
#' @examples
#' \dontrun{
#'  models = available.models()
#'  models
#' }
#'
#' @export
available.models = function () {
  json.data = jsonlite::fromJSON("https://genai.gd.edu.kg/model.json")
  return (json.data)
}
